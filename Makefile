#======================================================================
# GARIDOMAKARONADA MAKEFILE
#======================================================================
# Usage:
#   make read           - Build colored PDF for reading (LuaLaTeX)
#   make print          - Build B&W PDF for printing (LuaLaTeX)
#   make all            - Build both
#   make clean          - Remove artifacts
#======================================================================

FILE = Garidomakaronada_NN
LUALATEX = lualatex
FLAGS = -interaction=nonstopmode

# Paths
SCRIPT = Garidomakaronada_Template/convert_exams.py
SOURCE = Garidomakaronada.tex
OUT = $(FILE).tex

.PHONY: all read print clean transform

all: read print

# Transform Source -> Target (using the Python script)
transform:
	@echo "Running transformation script..."
	# python3 $(SCRIPT) $(SOURCE) $(OUT)

# Build Read Mode
read: transform
	@echo "Building READ mode (Color)..."
	$(LUALATEX) $(FLAGS) --jobname=$(FILE)_Read $(FILE).tex || true
	$(LUALATEX) $(FLAGS) --jobname=$(FILE)_Read $(FILE).tex || true
	@if [ -f $(FILE)_Read.pdf ]; then \
		echo "Cleaning up auxiliary files..."; \
		rm -f *.aux *.log *.out *.toc; \
		echo "Done: $(FILE)_Read.pdf"; \
	else \
		echo "Error: PDF generation failed!"; \
		exit 1; \
	fi

# Build Print Mode
print: transform
	@echo "Building PRINT mode (B&W)..."
	$(LUALATEX) $(FLAGS) --jobname=$(FILE)_Print "\def\printmodeflag{}\input{$(FILE).tex}" || true
	$(LUALATEX) $(FLAGS) --jobname=$(FILE)_Print "\def\printmodeflag{}\input{$(FILE).tex}" || true
	@if [ -f $(FILE)_Print.pdf ]; then \
		echo "Cleaning up auxiliary files..."; \
		rm -f *.aux *.log *.out *.toc; \
		echo "Done: $(FILE)_Print.pdf"; \
	else \
		echo "Error: PDF generation failed!"; \
		exit 1; \
	fi

clean:
	rm -f *.aux *.log *.out *.toc *.pdf
