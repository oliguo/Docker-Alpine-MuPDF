# Docker-Alpine-MuPDF

```
A program runs to extra the thumbnail and table of contents by mupdf and crontab in the docker alpine
```

## Git clone and Download the mupdf and unzip the source from zip to 'source' folder
```
wget https://mupdf.com/downloads/archive/mupdf-1.17.0-source.tar.gz
unzip mupdf-1.17.0-source.tar.gz mupdf-1.17.0-source
mv mupdf-1.17.0-source source
```

## Convert shell
```
#!/bin/sh
lock_dir=/var/tmp/mylock
pid_file=/var/tmp/mylock/pid
pdf_folder='/opt/data/pdf/*.pdf'
toc_path='/opt/data/toc'
thumbnail_path='/opt/data/thumbnail'
if (mkdir ${lock_dir}) 2>/dev/null; then
        echo $$ >${pid_file}
        echo  `date`':run'
        trap 'rm -rf "$lock_dir"; exit $?' INT TERM EXIT
        # start the program
        for _pdf_ in $pdf_folder; do
                _toc_csv_=$toc_path'/'"$(basename ${_pdf_} .pdf)"'.csv'
                if [ -f "${_toc_csv_}" ]; then
                        echo "${_toc_csv_} exists."
                else
                        mutool show ${_pdf_} outline > ${_toc_csv_}
                fi
                _thumbnail_png_=$thumbnail_path'/'"$(basename ${_pdf_} .pdf)"'.png'
                if [ -f "${_thumbnail_png_}" ]; then
                        echo "${_thumbnail_png_} exists."
                else
                        mutool draw -o ${_thumbnail_png_} -F png ${_pdf_} 1-1 
                fi
        done
        # clean up
        rm -rf "${lock_dir}"
        trap - INT TERM EXIT
else
        echo "Lock Exists: ${lock_dir} owned by $(cat ${pid_file})"
fi
```
