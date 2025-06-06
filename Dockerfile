FROM ocaml/opam

ARG creusot_ref=main

# Install dependencies
USER root
RUN apt-get update && apt-get install -y libssl-dev pkg-config autoconf \
    automake libtool libzmq3-dev libgtk-3-dev libgtksourceview-3.0-dev \
    libcairo-dev zlib1g-dev libgmp-dev && apt-get clean
USER opam

# Install Rust via rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/opam/.cargo/bin:${PATH}"

# Install Creusot
ADD --chown=opam:opam https://github.com/creusot-rs/creusot.git#${creusot_ref} /home/opam/creusot
RUN cd /home/opam/creusot && ./INSTALL

ENTRYPOINT ["/home/opam/creusot/target/release/cargo-creusot", "creusot"]
