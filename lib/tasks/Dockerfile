FROM base:ruby22
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update
RUN apt-get install -y python-pip
RUN git clone https://github.com/AndyMoreland/spearmint.git
WORKDIR /spearmint
RUN bundle install
RUN pip install -r requirements.txt
