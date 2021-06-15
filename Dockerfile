FROM python:3.7
ENV PYTHONUNBUFFERED=1

EXPOSE 8501
WORKDIR /app

#WORKDIR /usr/app/src

RUN apt-get -y update  && apt-get install -y \
  python3-dev \
  libpng-dev \
  apt-utils \
  python-psycopg2 \
  python-dev \
  postgresql-client \
&& rm -rf /var/lib/apt/lists/* 

RUN apt-get install libevent-dev

RUN apt-get install -y libssl-dev

RUN echo 'deb http://ftp.us.debian.org/debian/ stretch main contrib non-free' > /etc/apt/sources.list.d/stretch.list && \
apt-get update && \
apt-get install -y --no-install-recommends openjdk-8-jre-headless && \
rm /etc/apt/sources.list.d/stretch.list && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

#Install spark 2.4.7
#RUN wget http://apache.mirror.anlx.net/spark/spark-2.4.7/spark-2.4.7-bin-hadoop2.7.tgz
#RUN tar -xzf spark-2.4.7-bin-hadoop2.7.tgz
#RUN mv spark-2.4.7-bin-hadoop2.7 /spark
#RUN rm spark-2.4.7-bin-hadoop2.7.tgz

#RUN wget https://www.apache.org/dyn/closer.lua/spark/spark-2.4.7/spark-2.4.7-bin-#hadoop2.7.tgz
RUN wget https://archive.apache.org/dist/spark/spark-2.4.7/spark-2.4.7-bin-hadoop2.7.tgz
#RUN tar -xzf spark-2.4.7-bin-hadoop2.7.tgz
RUN tar xf spark-2.4.7-bin-hadoop2.7.tgz
RUN mv spark-2.4.7-bin-hadoop2.7 /spark
RUN rm spark-2.4.7-bin-hadoop2.7.tgz

# Install Scala
RUN wget https://downloads.lightbend.com/scala/2.11.12/scala-2.11.12.rpm

RUN apt-get update && apt-get -y install gcc
RUN apt-get update && apt-get -y install g++

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

#RUN mkdir -p /root/.streamlit

#RUN bash -c 'echo -e "\
#[general]\n\
#email = \"\"\n\
#" > /root/.streamlit/credentials.toml'

#RUN bash -c 'echo -e "\
#[server]\n\
#enableCORS = false\n\
#" > /root/.streamlit/config.toml'

COPY . .
#COPY app ./
CMD streamlit run app.py
#CMD ["sh", "-c", "streamlit run --server.port - "8501" /app/app.py"]
