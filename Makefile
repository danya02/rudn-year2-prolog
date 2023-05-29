all: conv

dev:
	jupyter-notebook

conv: conv-lab1 conv-lab2

conv-lab1:
	jupyter-nbconvert --to python Lab1.ipynb
	python3 nbconvert_to_pl.py Lab1.py

conv-lab2:
	jupyter-nbconvert --to python Lab2.ipynb
	python3 nbconvert_to_pl.py Lab2.py

clean:
	rm *.pl
