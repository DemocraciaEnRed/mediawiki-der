# mediawiki-der

Para usar simplemente hacer `docker-compose up` dentro de la carpeta del proyecto.

Asegurarse de tener el puerto `8080` libre o cambiar la configuración de `ports` y la variable de entorno `MW_SITE_SERVER` en `docker-compose.yml`. Para cambiar la ip/dominio de la wiki es necesario rebuildear.

Credenciales por defecto del admin: `admin` `123123123`.


Si en algún momento desean debugear un error agregar la siguiente línea a `LocalSettings.php` del contenedor:
`$wgShowExceptionDetails = true; $wgDebugToolbar = true; $wgShowDebug = true; $wgDevelopmentWarnings = true; $wgDebugLogFile = "/tmp/{$wgSitename}-debug.log";`
