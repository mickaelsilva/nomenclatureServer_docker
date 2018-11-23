FROM ubuntu:16.04
MAINTAINER UMMI
LABEL email="ummimicro@medicina.ulisboa.pt"

RUN apt-get update &&\
    apt-get install -y p7zip-full aptitude nginx redis-server postgresql git python3 python3-pip wget screen && \
    apt-get autoclean -y
    
RUN DEBIAN_FRONTEND=noninteractive aptitude install --no-gui -y virtuoso-opensource
RUN python3 -m pip install --upgrade pip
RUN ufw allow 'Nginx HTTP'


RUN service service virtuoso-opensource-6.1 status
#RUN service service virtuoso-opensource-6.1 restart

#route app and virtuoso in nginx to 80 port
RUN cp myconf.conf /etc/nginx/sites-available/
RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-sites-enabled/default
RUN ln -s /etc/nginx/sites-available/myconf.conf /etc/nginx/sites-enabled/
RUN service nginx restart

# setup the app
WORKDIR /NS/
RUN git clone https://github.com/Amfgcp/NS/tree/NS_typon
RUN pip3 install -r ./NS_typon/requirements.txt

COPY ./NS_typon/virtuoso.db /var/lib/virtuoso-opensource-6.1/db/
RUN service service virtuoso-opensource-6.1 start
#RUN 'python3 -m venv flask'
