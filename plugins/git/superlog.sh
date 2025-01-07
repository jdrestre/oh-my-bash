#!/bin/bash
# Muestra el log detallado y cuenta modificaciones por archivo, ordenando y listando hasta el primer archivo con una sola modificación

# Mostrar el superlog original
git log --graph --decorate --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset%n%B%Cgreen(%ar) %C(bold blue)<%an>%Creset --> %C(bold yellow)%ad%Creset' --abbrev-commit --date=format:'%A, %d %b %Y %H:%M' --stat

echo ""
echo "Modificaciones por archivo (ordenado, hasta 1 cambio):"
echo ""

# Obtener la lista de archivos y contar las modificaciones
files=$(git ls-tree -r HEAD --name-only)
for file in $files; do
  count=$(git log --oneline -- $file | wc -l)
  echo "$count $file"
done | sort -nr | awk '{print; if ($1 == 1) exit}'
