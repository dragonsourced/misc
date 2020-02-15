CC     ?= c99
BINDIR ?= ../bin
EXE     = run

SRC != find -name '*.c'
OBJ != echo ${SRC} | sed 's/.c\b/.o/g'

CFLAGS  = -Wall
LDFLAGS =
LIBS    =

default: ${EXE}

OBJS != find -name '*.o'

clean:
	rm -f ${OBJS} ${EXE}

${EXE}: ${OBJ}
	${CC} ${OBJ} ${CLFAGS} ${LDFLAGS} ${LIBS} -o ${EXE}

install: ${EXE}
	mkdir -p ${BINDIR}
	mv ${EXE} ${BINDIR}/${EXE}

uninstall:
	rm -f ${BINDIR}/${EXE}
