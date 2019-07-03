# mediawiki-der

Para usar simplemente hacer `docker-compose up` dentro de la carpeta del proyecto.

En el primer buildeo los logs se traban unos segundos en el container `db` y después de 15 segundos buildea `web`.

Asegurarse de tener el puerto `8080` libre o cambiar la configuración de `ports` y la variable de entorno `MW_SITE_SERVER` en `docker-compose.yml`.

Credenciales por defecto del admin: `admin` `123123123`.

Para cambiar la ip/domion de la wiki es necesario rebuildear.
