# Instalador Multitenant de ERPNext en Portainer

Este repositorio contiene un script para desplegar nuevas instancias multitenant de ERPNext sobre un stack de Portainer con Traefik.

## 🚀 Uso rápido

```bash
bash <(curl -s https://raw.githubusercontent.com/tendenciadigitalio/frappe---Multitenant/main/deploy-frappe.sh)
```

## 📋 Requisitos

- Tener acceso a tu servidor vía SSH
- Tener el contenedor `erpnext_backend` activo
- Tener configurado un stack con Traefik como proxy inverso

## 🔧 Qué hace este script

1. Crea un nuevo sitio Frappe
2. Instala la app ERPNext
3. Configura el dominio para multitenencia
4. Habilita el scheduler
5. Imprime instrucciones para actualizar tu `stack.yml` con el nuevo dominio

## 🛠 Edición del stack

Recuerda añadir el nuevo dominio en tu `stack.yml` en el bloque de labels como se muestra en el script.

---

© Tendencia Digital IO

