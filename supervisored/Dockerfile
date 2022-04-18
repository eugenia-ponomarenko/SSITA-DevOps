FROM alpine:3.15

COPY --chmod=777 ./install.sh /home/install.sh
RUN ./home/install.sh

COPY --chmod=777 ./postgres_service.sh /usr/bin/postgres_service.sh

COPY ./supervisord.ini /etc/supervisor.d/supervisord.ini

COPY ./citizen.war /opt/tomcat/latest/webapps/citizen.war

EXPOSE 9001 8080

CMD ["/usr/bin/supervisord"]