all: conv

dev:
	jupyter-notebook

conv: conv-lab1

conv-lab1:
	jupyter-nbconvert --to python Lab1.ipynb
	python3 nbconvert_to_pl.py Lab1.py
