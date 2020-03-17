CFLAGS
LDFLAGS
OBJ
EXE

${EXE}: ${OBJ}
	${CC} ${CFLAGS} ${LDFLAGS} ${OBJ} -o ${EXE}

clean:
	rm -f ${OBJ} ${EXE}
