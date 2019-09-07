#!/bin/bash

DRY_RUN=true

# Determine where to store old configs
SOURCE_DIR="."
ARCHIVE_DIR="${HOME}/.configs/$(date +%Y%m%d_%H%M%S)"
mkdir -p "${ARCHIVE_DIR}"
printf "Archiving config files to %s...\n" "${ARCHIVE_DIR}"

# Iterate through all files in config-file
find "${SOURCE_DIR}" -type f -maxdepth 1 -exec ls -ld {} \; \
    |awk '{ gsub("^.*/","",$9); printf "%s\n", $9; }' \
    |while read -r file
do
    # If file already exists, throw it into archive
    if [[ -f "${HOME}/${file}" && "${file}" != "$0" ]]; then
        [[ ${DRY_RUN} = false ]] \
            && mv "${HOME}/${file}" "${ARCHIVE_DIR}" 
        printf "Archived %s\n" "${file}"
    fi

    [[ ${DRY_RUN} = false ]] \
        && cp "${SOURCE_DIR}/${file}" "${HOME}"
done

# Back up old VIM folder and install plugins
printf "Setting up VIM...\n"
if [[ ${DRY_RUN} = false ]]; then
    cp "${HOME}/.vim" "${ARCHIVE_DIR}"
    mkdir -p "${HOME}/.vim"
    vim +PlugInstall +qall  
fi

revert() {
    printf "\nReverting...\n"
    # Iterate through all files in config-file
    find "${SOURCE_DIR}" -type f -maxdepth 1 -exec ls -ld {} \; \
        |awk '{ gsub("^.*/","",$9); printf "%s\n", $9; }' \
        |while read -r file; do
        # Move file out of archive
        if [[ -f "${ARCHIVE_DIR}/${file}" ]]; then
            [[ ${DRY_RUN} = false ]] \
                && mv "${ARCHIVE_DIR}/${file}" "${HOME}"
            printf "Unarchived %s\n" "${file}"
        fi
    done
}

# TODO: ENTER does not continue with &&, but rather goes straight to revert
(read -r -t 60 -p "Test out a terminal and VIM. If everything works fine, hit ENTER. Otherwise, things will revert in 60 seconds. (ENTER)" \
    && [[ ${DRY_RUN} = false ]] \
    && mv "${HOME}/.git" "${ARCHIVE_DIR}" \
    && cp -r "${SOURCE_DIR}/.git" "${HOME}") \
    || revert

