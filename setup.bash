#!/bin/bash

# setup.bash sets up your home directory with the desired configs and 
# VIM plugins. It also moves the previous config files to an archive.

# TODO: clean stuff up

DRY_RUN=false
if [[ ${DRY_RUN} = true ]]; then  
    printf "[Warning]: Dry run. No files will be moved.\n"
    printf "Modify setup.bash to set DRY_RUN=false\n"
fi

SOURCE_DIR="$(dirname $0)"  # only move from setup.bash's directory
ARCHIVE_DIR="${HOME}/.configs/$(date +%Y%m%d_%H%M%S)"


move-files() {
    # Create archive directory
    [[ ${DRY_RUN} = false ]] && mkdir -p "${ARCHIVE_DIR}"
    printf "Archiving config files to %s\n" "${ARCHIVE_DIR}"

    # Iterate through all files in config-file
    find "${SOURCE_DIR}" -type f -maxdepth 1 -exec ls -ld {} \; \
        |awk '{ gsub("^.*/","",$9); printf "%s\n", $9; }' \
        |while read -r file
    do
        # If file already exists, throw it into archive
        if [[ -f "${HOME}/${file}" && "${file}" != "$(basename $0)" ]]; then
            if [[ ${DRY_RUN} = false ]]; then
                mv "${HOME}/${file}" "${ARCHIVE_DIR}" || return 1
            fi
            printf "Archived %s\n" "${HOME}/${file}"
        fi

        # Move config files to home directory
        if [[ "${file}" != "$(basename $0)" && ${DRY_RUN} = false ]]; then
            cp "${SOURCE_DIR}/${file}" "${HOME}" || return 1
        fi
    done || return 1
}

setup-vim() {
    # Back up old VIM folder and install plugins
    printf "Setting up VIM...\n"
    if [[ ${DRY_RUN} = false ]]; then
        if [[ -d "${HOME}/.vim" ]]; then
            cp -r "${HOME}/.vim" "${ARCHIVE_DIR}"
        fi
        mkdir -p "${HOME}/.vim"
        vim +PlugInstall +qall || return 1
    fi
}

finalize-move() {
    printf "Moving .git to home directory to finalize setup.\nThank you for your time.\n"
    if [[ ${DRY_RUN} = false ]]; then
        [[ -d "${HOME}/.git" ]] && mv "${HOME}/.git" "${ARCHIVE_DIR}" 
        cp -r "${SOURCE_DIR}/.git" "${HOME}"
    fi
}

revert() {
    printf "Reverting...\n"
    # Iterate through all files in config-file
    find "${SOURCE_DIR}" -type f -maxdepth 1 -exec ls -ld {} \; \
        |awk '{ gsub("^.*/","",$9); printf "%s\n", $9; }' \
        |while read -r file; do

        # Move file out of archive
        if [[ -f "${ARCHIVE_DIR}/${file}" ]]; then
            if [[ ${DRY_RUN} = false ]]; then
                mv "${ARCHIVE_DIR}/${file}" "${HOME}" || return 1
            fi
            printf "Unarchived %s\n" "${file}"
        elif [[ -f "${HOME}/${file}" ]]; then
            if [[ ${DRY_RUN} = false ]]; then
                rm "${HOME}/${file}"
            fi
            printf "Removed %s\n" "${file}"
        fi
    done || return 1
    
    # Delete generated .vim
    if [[ -d "${HOME}/.vim" ]]; then 
        printf "Restoring .vim/\n"
        rm -rf "${HOME}/.vim"
    fi

    # Move .vim out of archive
    if [[ -d "${ARCHIVE_DIR}/.vim" ]]; then 
        mv "${ARCHIVE_DIR}/.vim" "${HOME}" || return 1
    fi

    # Clean up archive
    [[ -d "${ARCHIVE_DIR}" ]] && (rmdir "${ARCHIVE_DIR}" || return 1)
    
    printf "Done reverting.\n"
}


# if __name__ == '__main__': 

(move-files && setup-vim) \
    || (printf "Something went wrong..." && revert ) \
    || printf "Uh oh... something seriously went wrong and we couldn't revert."

timeout=60
printf "\nTest out a terminal and VIM. Otherwise, things will revert in %s seconds.
\tType \"YES\" if everything works fine.
\t(Submit anyting else to revert.)
\t" "${timeout}"
read -r -t ${timeout} confirmation

if [[ "${confirmation}" == "YES" ]]; then
    finalize-move
    printf "You can now run git commands from within your home directory.
    Try \`git push\`ing changes to your config files. Happy configuring!\n"
else
    revert || printf "Uh oh... we couldn't revert. Got 'em ...?\n"
fi
