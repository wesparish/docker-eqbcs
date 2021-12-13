FROM ubuntu:18.04


COPY eqbcs /eqbcs
RUN useradd -u 1000 eqbcs && \
    chown 1000:1000 /eqbcs && \
    chmod +x /eqbcs

USER eqbcs

EXPOSE 2112

#Usage: eqbcs [options]
#  Options are as follows:
#  -p <port>     Port to listen on
#  -i <addr>     IP Address to bind to
#  -l <file>     Output to logfile rather than STDOUT
#  -d            Run as daemon (UNIX only)
CMD ["sh", "-c", "/eqbcs"]
