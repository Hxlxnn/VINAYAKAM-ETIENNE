all:exec

t.o: t.c
	gcc -c t.c-o t.o
	
s.o: s.c
	gcc -c s.c -o s.o
exec: t.o s.o
	gcc t.o s.o -o exec
	
clean:
	rm -f *.o
	rm -f exec
