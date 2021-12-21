FROM python:3

COPY eqbcs /eqbcs
RUN useradd -u 1000 eqbcs && \
    chown 1000:1000 /eqbcs && \
    chmod +x /eqbcs && \
    mkdir -p /home/eqbcs && \
    chown -R 1000:1000 /home/eqbcs

USER eqbcs

EXPOSE 2112 8080

# Install wtee to tee to web
RUN pip3 install wtee

#Usage: eqbcs [options]
#  Options are as follows:
#  -p <port>     Port to listen on
#  -i <addr>     IP Address to bind to
#  -l <file>     Output to logfile rather than STDOUT
#  -d            Run as daemon (UNIX only)
CMD ["sh", "-c", "/eqbcs | /home/eqbcs/.local/bin/wtee -b 0.0.0.0:8080 | nl"]
