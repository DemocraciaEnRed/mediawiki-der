FROM mediawiki:1.32.2

RUN apt update && apt install -y unzip nano
RUN curl -S https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin –filename=composer

####EXTENSIONES
WORKDIR /var/www/html/extensions

#VisualEditor extension
RUN git clone --recurse-submodules -b REL1_32 https://gerrit.wikimedia.org/r/mediawiki/extensions/VisualEditor.git

#TemplateStyles extension (para templates del editor)
RUN curl -S https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/extensions/TemplateStyles/+archive/REL1_32.tar.gz | tar xz --one-top-level=TemplateStyles
RUN cd TemplateStyles && php /usr/local/bin/composer.phar update --no-dev

#PluggableAuth + OpenID extensions (para keycloack)
RUN curl -S https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/extensions/PluggableAuth/+archive/REL1_32.tar.gz | tar xz --one-top-level=PluggableAuth
RUN curl -S https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/extensions/OpenIDConnect/+archive/REL1_32.tar.gz | tar xz --one-top-level=OpenIDConnect
RUN cd OpenIDConnect && php /usr/local/bin/composer.phar update --no-dev

#Echo + Flow extensions (para las discusiones)
RUN curl -S https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/extensions/Echo/+archive/REL1_32.tar.gz | tar xz --one-top-level=Echo
RUN cd Echo && php /usr/local/bin/composer.phar update --no-dev
RUN curl -S https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/extensions/Flow/+archive/REL1_32.tar.gz | tar xz --one-top-level=Flow
RUN cd Flow && php /usr/local/bin/composer.phar update --no-dev

#EditNotify
RUN curl -S https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/extensions/EditNotify/+archive/REL1_32.tar.gz | tar xz --one-top-level=EditNotify
RUN pear install mail net_smtp
RUN cd EditNotify/i18n && cp en.json es.json && sed -i -e 's/was modified/tuvo modificaciones/' -e 's/was created/fue creada/' -e 's/Page/La página/' es.json

####OTROS
#Mobile skins
#WORKDIR /var/www/html/skins
#RUN git clone --recurse-submodules https://github.com/hutchy68/pivot.git
#RUN echo '.oo-ui-tool .oo-ui-tool-link{ padding-top: 0em !important; }' >> pivot/assets/stylesheets/pivot.css 
#RUN git clone --recurse-submodules --branch v2.2.0 https://github.com/thingles/foreground.git
#RUN git clone --recurse-submodules --branch v1.1.0 https://github.com/thaider/Tweeki.git

#SVG support
RUN echo 'La siguiente operación puede tardar unos segundos' \
	&& echo "El mensaje 'debconf: delaying package configuration...' es normal" \ 
	&& apt install librsvg2-bin -y >/dev/null

#Dejar en root para la shell
WORKDIR /var/www/html

RUN echo ServerName web>> /etc/apache2/apache2.conf 

COPY icons images/icons
COPY LocalSettings.php LocalSettingsINIT.php
ENTRYPOINT if [ ! -f LocalSettings.php ]; then \
		sleep 17; \
		php maintenance/install.php \
	        --confpath "/" \
	        --dbserver "$MW_DB_SERVER" \
	        --dbtype "$MW_DB_TYPE" \
	        --dbname "$MW_DB_NAME" \
	        --dbuser "$MW_DB_USER" \
	        --dbpass "$MW_DB_PASSWORD" \
	        --installdbuser "$MW_DB_INSTALLDB_USER" \
	        --installdbpass "$MW_DB_INSTALLDB_PASS" \
	        --server "$MW_SITE_SERVER" \
	        --scriptpath "$MW_WEB_PATH" \
	        --lang "$MW_SITE_LANG" \
	        --pass "$MW_ADMIN_PASS" \
	        "$MW_SITE_NAME" \
	        "$MW_ADMIN_USER"; \
		mv LocalSettingsINIT.php LocalSettings.php; \
		php maintenance/update.php --quick; \
		php maintenance/populateContentModel.php --wiki=somewiki --ns=1 --table=revision; \
		php maintenance/populateContentModel.php --wiki=somewiki --ns=1 --table=archive; \
		php maintenance/populateContentModel.php --wiki=somewiki --ns=1 --table=page; \
		fi; \
	exec apachectl -e info -D FOREGROUND

