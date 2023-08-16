# This Dockerfile requires local image built in this way:
# docker build -t elements_build_machine -f elements_build_machine.Dockerfile . 
# in repo: https://github.com/goatpig/bdb48


FROM elements_build_machine as elementsd_src_build

WORKDIR /app
COPY . /app/

RUN sh autogen.sh

WORKDIR /app/build
RUN ../configure --without-gui --prefix=/bitcoin/elements-22.1.1

RUN make -j15

RUN make install


FROM elements_build_machine as elementsd_container_image

WORKDIR /bitcoin
RUN mkdir .elements
COPY --from=elementsd_src_build /bitcoin/elements-22.1.1/ /bitcoin/elements-22.1.1/