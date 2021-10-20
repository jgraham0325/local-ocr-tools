#/bin/bash
# Takes an input set of PDF files (can be in subfolders) and OCRs them
# Output is a new directory with OCR results in text documents, plus a new PDF with the OCR text inside
# To install on MacOS with brew, run: brew install ocrmypdf && brew install parallel

SECONDS=0 # used for timing total duration

INPUT_FOLDER="ocr-input"
OUTPUT_FOLDER="output-ocr"
rm output-ocr/*

COUNT=$( find $INPUT_FOLDER -name '*.pdf' | wc -l )
echo No. documents to process: $COUNT

find $INPUT_FOLDER -name '*.pdf' | parallel --tag -j 4 ocrmypdf -l eng --optimize 0 --output-type pdf --force-ocr --sidecar "$OUTPUT_FOLDER/{/.}.txt" '{}' "$OUTPUT_FOLDER/{/.}-ocr.pdf"

TOTAL_DURATION=$SECONDS
echo "Total Time for $COUNT PDFs (s): $TOTAL_DURATION"
AVG_DURATION=$( echo "scale=2; $TOTAL_DURATION / $COUNT" | bc )
echo "Average duration per document (s): $AVG_DURATION"
