#!/bin/bash
# update-image.sh - Gestiona versiones de imágenes Docker usando Renovate

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Función para detectar actualizaciones usando Renovate
detect_updates() {
    # Ejecutar renovate silenciosamente
    RENOVATE_CONFIG_FILE=renovate.json5 LOG_LEVEL=debug npx -y renovate \
        --platform=local \
        --onboarding=false \
        --require-config=ignored \
        --dry-run=lookup > /tmp/renovate-full.log 2>&1

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}� TODAS LAS IMÁGENES DETECTADAS${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    local total=0
    local updated=0
    local needs_update=0
    local update_commands=()

    while IFS= read -r line; do
        if [[ "$line" =~ \"depName\":\ *\"([^\"]+)\" ]]; then
            local dep_name="${BASH_REMATCH[1]}"

            # Contar todas (incluyendo custom)
            ((total++))

            # Saltar solo para mostrar detalles de custom
            if [[ "$dep_name" =~ elmariovi ]]; then
                local context
                context=$(grep -A 10 "\"depName\": \"$dep_name\"" /tmp/renovate-full.log | head -15)
                local current
                current=$(echo "$context" | grep -oP '"currentValue":\s*"\K[^"]+' | head -1)
                echo -e "📦 ${BLUE}${dep_name}${NC}"
                echo -e "   ${YELLOW}${current}${NC} (custom - ignorada)"
                echo ""
                continue
            fi

            # Extraer contexto limitado pero suficiente, parando en el siguiente depName
            local context
            context=$(grep -A 50 "\"depName\": \"$dep_name\"" /tmp/renovate-full.log | awk '
                NR==1 { print; next }
                /"depName":/ { exit }
                { print }
            ')

            local current
            local new_version
            current=$(echo "$context" | grep -oP '"currentValue":\s*"\K[^"]+' | head -1)

            # Buscar si hay actualización disponible (solo en este bloque)
            if echo "$context" | grep -q '"updates":\s*\['; then
                # Verificar si el array updates tiene contenido (no está vacío)
                if echo "$context" | grep -q '"updates":\s*\[\s*\]'; then
                    # Array vacío = no hay actualizaciones
                    ((updated++))
                    echo -e "📦 ${BLUE}${dep_name}${NC}"
                    echo -e "   ${GREEN}${current}${NC} ✓"
                    echo ""
                else
                    # Array con contenido = buscar newVersion
                    new_version=$(echo "$context" | grep -oP '"newVersion":\s*"\K[^"]+' | head -1)

                    if [ -n "$new_version" ] && [ "$current" != "$new_version" ]; then
                        ((needs_update++))
                        echo -e "📦 ${BLUE}${dep_name}${NC}"
                        echo -e "   ${RED}${current}${NC} → ${GREEN}${new_version}${NC} ${YELLOW}⚠ ACTUALIZACIÓN DISPONIBLE${NC}"
                        echo ""
                        update_commands+=("${dep_name}:${current}:${new_version}")
                    else
                        ((updated++))
                        echo -e "📦 ${BLUE}${dep_name}${NC}"
                        echo -e "   ${GREEN}${current}${NC} ✓"
                        echo ""
                    fi
                fi
            else
                # No hay campo updates
                ((updated++))
                echo -e "📦 ${BLUE}${dep_name}${NC}"
                echo -e "   ${GREEN}${current}${NC} ✓"
                echo ""
            fi
        fi
    done < <(grep '"depName"' /tmp/renovate-full.log)

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📊 RESUMEN:${NC}"
    echo -e "   Total detectadas: ${BLUE}${total}${NC}"
    echo -e "   ${GREEN}✓${NC} Actualizadas: ${updated}"
    echo -e "   ${YELLOW}⚠${NC} Disponibles: ${needs_update}"
    echo ""

    if [ $needs_update -gt 0 ]; then
        echo -e "${YELLOW}💡 Para actualizar todas:${NC}"
        echo -e "   ${CYAN}./update-image.sh apply${NC}"
    fi

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Función para aplicar todas las actualizaciones
apply_all_updates() {
    echo -e "${YELLOW}Aplicando actualizaciones...${NC}"
    echo ""

    local updated=0

    while IFS= read -r line; do
        if [[ "$line" =~ \"depName\":\ *\"([^\"]+)\" ]]; then
            local dep_name="${BASH_REMATCH[1]}"

            if [[ ! "$dep_name" =~ elmariovi ]]; then
                # Extraer contexto hasta el siguiente depName
                local context
                context=$(grep -A 50 "\"depName\": \"$dep_name\"" /tmp/renovate-full.log | awk '
                    NR==1 { print; next }
                    /"depName":/ { exit }
                    { print }
                ')

                # Verificar si hay updates no vacío
                if echo "$context" | grep -q '"updates":\s*\[' && ! echo "$context" | grep -q '"updates":\s*\[\s*\]'; then
                    local current
                    local new_version
                    current=$(echo "$context" | grep -oP '"currentValue":\s*"\K[^"]+' | head -1)
                    new_version=$(echo "$context" | grep -oP '"newVersion":\s*"\K[^"]+' | head -1)

                    if [ -n "$new_version" ] && [ "$current" != "$new_version" ]; then
                        echo -e "  ${BLUE}${dep_name}${NC}: ${current} → ${GREEN}${new_version}${NC}"

                        # Actualizar en todos los archivos job.hcl
                        find . -name "job.hcl" -type f -exec sed -i "s|${dep_name}:${current}|${dep_name}:${new_version}|g" {} \;
                        ((updated++))
                    fi
                fi
            fi
        fi
    done < <(grep '"depName"' /tmp/renovate-full.log)

    echo ""
    echo -e "${GREEN}✅ ${updated} imágenes actualizadas${NC}"
}

# Función principal
main() {
    local mode=${1:-detect}

    if [ "$mode" = "detect" ] || [ "$mode" = "" ]; then
        detect_updates

    elif [ "$mode" = "apply" ]; then
        # Primero detectar
        RENOVATE_CONFIG_FILE=renovate.json5 LOG_LEVEL=debug npx -y renovate \
            --platform=local \
            --onboarding=false \
            --require-config=ignored \
            --dry-run=lookup > /tmp/renovate-full.log 2>&1

        apply_all_updates

    elif [ "$mode" = "update" ]; then
        local target_image=${2:-}
        local new_version=${3:-}

        if [ -z "$target_image" ] || [ -z "$new_version" ]; then
            echo -e "${RED}Error: Especifica imagen y versión${NC}"
            echo "Uso: $0 update \"docker.io/grafana/grafana:12.4.0\" \"12.5.0\""
            exit 1
        fi

        echo -e "${YELLOW}Actualizando...${NC}"

        # Actualizar en todos los archivos
        local updated=0
        local image_name
        image_name=$(echo "$target_image" | sed 's/:.*$//')
        local new_image="${image_name}:${new_version}"

        while IFS= read -r file; do
            if grep -q "$target_image" "$file"; then
                sed -i "s|${target_image}|${new_image}|g" "$file"
                echo -e "${GREEN}✓${NC} $file"
                ((updated++))
            fi
        done < <(find . -name "job.hcl")

        if [ $updated -eq 0 ]; then
            echo -e "${RED}Imagen no encontrada${NC}"
            exit 1
        fi

        echo -e "${GREEN}✅ ${updated} archivos actualizados${NC}"

    else
        echo "Uso:"
        echo "  $0          - Detectar actualizaciones"
        echo "  $0 apply    - Aplicar todas"
        echo "  $0 update <imagen> <versión>"
    fi
}

main "$@"
