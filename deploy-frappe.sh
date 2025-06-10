#!/bin/bash

# =============================
# Script de instalación multitenant de ERPNext en Portainer
# =============================
# Este script debe ejecutarse en el servidor que contiene los contenedores de Portainer
# Requiere que 'docker' esté instalado y funcionando
# =============================

# Preguntar al usuario los datos necesarios
read -p "📛 Nombre del nuevo sitio (ej. cliente1.tudominio.com): " SITIO
read -p "🔐 Contraseña root de MySQL (contenedor erpnext_db): " MYSQL_PASS

# Ejecutar dentro del contenedor backend
echo "🔄 Accediendo al contenedor erpnext_backend..."
docker exec -i erpnext_erpnext_backend.1.v5ebvbyragxdv59qjkzjim08j bash <<EOF
cd /home/frappe/frappe-bench

# Eliminar si existe una instalación previa
if [ -d "sites/\$SITIO" ]; then
  echo "⚠️ Sitio ya existe. Eliminando..."
  rm -rf sites/\$SITIO
fi

# Crear nuevo sitio
bench new-site \$SITIO --mariadb-root-password \$MYSQL_PASS <<END
\$MYSQL_PASS
admin
admin
END

# Instalar ERPNext
bench --site \$SITIO install-app erpnext

# Configurar multitenencia
bench config dns_multitenant on
bench --site \$SITIO set-config host_name \$SITIO

# Generar configuración interna de nginx
bench setup nginx

# Activar scheduler
bench --site \$SITIO enable-scheduler
EOF

# Instrucciones para el usuario
echo -e "\n✅ El sitio \$SITIO ha sido creado correctamente."
echo -e "\n🔧 Ahora edita tu archivo stack de Portainer y agrega el dominio \$SITIO en el bloque de labels de Traefik bajo el servicio 'erpnext_frontend'."
echo -e "\nEjemplo de línea modificada en tu stack.yml:"
echo -e "  - traefik.http.routers.erpnext_frontend.rule=Host(\`tdcrm.tendenciadigital.top\`) || Host(\`\$SITIO\`)"
echo -e "\nTambién asegúrate de tener las siguientes líneas si no existen en ese bloque de labels:"
echo -e "  - traefik.enable=true"
echo -e "  - traefik.http.services.erpnext_frontend.loadbalancer.server.port=8080"
echo -e "  - traefik.http.routers.erpnext_frontend.service=erpnext_frontend"
echo -e "  - traefik.http.routers.erpnext_frontend.tls.certresolver=letsencryptresolver"
echo -e "  - traefik.http.routers.erpnext_frontend.entrypoints=websecure"
echo -e "  - traefik.http.routers.erpnext_frontend.tls=true"
echo -e "\n🚀 Una vez actualizado el stack, ejecuta desde tu servidor:"
echo -e "docker stack deploy -c stack.yml erpnext"
echo -e "\n🌐 Luego accede al sitio en tu navegador: https://\$SITIO"

echo -e "\n📁 Este script fue diseñado para facilitar nuevas instalaciones multitenant de ERPNext en Portainer."
echo -e "\n💡 Sube este archivo a tu repositorio de GitHub y ejecútalo desde tu servidor con:"
echo -e "bash <(curl -s https://raw.githubusercontent.com/tu_usuario/tu_repo/main/deploy-frappe.sh)"

exit 0
