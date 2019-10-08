# mediawiki-der

### Infraestructura general de servicios
Este software está basado en [MediaWiki](https://www.mediawiki.org/wiki/MediaWiki/es). Por ende, cuenta con un servidor web, Apache+PHP, y una base de datos MySql. Además, al utilizar la extensión [VisualEditor](https://www.mediawiki.org/wiki/Extension:VisualEditor) para habilitar un editor visual tipo *office* en los artículos, también requiere de un servidor Node.js con [Parsoid](https://www.mediawiki.org/wiki/Parsoid). Esto resulta sumamente simple de implementar utilizando Docker. Afortunadamente MediaWiki tiene una [imagen oficial en DockerHub](https://hub.docker.com/_/mediawiki). Debido a compatibilidades con las extensiones que utilizamos, usamos la versión **1.32.2** de MediaWiki, como se puede apreciar en nuestro [Dockerfile](Dockerfile).

### Configuración de MediaWiki
Si bien la aplicación de MediaWiki está en PHP, es muy poco lo que se programa en este lenguage. Donde más se usa es en el archivo de configuración [LocalSettings.php](LocalSettings.php). Este archivo se genera automáticamente al utilizar el asistente de instalación de MediaWiki. Posteriormente le agregamos configuración personalizada, a partir de la línea *142* del mismo archivo.


.
.
.
Para usar simplemente hacer `docker-compose up` dentro de la carpeta del proyecto.

Asegurarse de tener el puerto `8080` libre o cambiar la configuración de `ports` y la variable de entorno `MW_SITE_SERVER` en `docker-compose.yml`. Para cambiar la ip/dominio de la wiki es necesario rebuildear.

Credenciales por defecto del admin: `admin` `123123123`.


Si en algún momento desean debugear un error agregar la siguiente línea a `LocalSettings.php` del contenedor:
`$wgShowExceptionDetails = true; $wgDebugToolbar = true; $wgShowDebug = true; $wgDevelopmentWarnings = true; $wgDebugLogFile = "/tmp/{$wgSitename}-debug.log";`
