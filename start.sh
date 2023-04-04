#!/bin/bash

#Wymaga załodowania ścieżki do plików fzf
source ~/.fzf.zsh

# Ustaw ścieżkę do folderu, który chcesz przeszukać
directory=$(dirname "$0")"/help/*"

# Przejrzyj folder i zapisz listę plików do zmiennej files
files=$(find $directory -type f -name "*.tsv" -printf "%p\n")

temp_file=$(mktemp)
echo -e "Polecenie\tOpis" > "$temp_file"

for file in $files; do
	cat "$file" >> "$temp_file"
  echo -e "\n" >> "$temp_file"
done

# --- Dla zwykłej konsoli ---
# command=$(cat "$temp_file" | fzf --header-lines=1 --layout=reverse-list | cut -f 1)
# echo $command; 

# --- Dla TMUX ---
command=$(cat "$temp_file" | fzf-tmux -p --header-lines=1 --layout=reverse-list | cut -f 1)
# Jeśli użytkownik wybrał polecenie, wyślij je do nowego okna w tmux
if [ -n "$command" ]; then
  pane_id=$(tmux display-message -p '#{pane_id}')
# Wyślij wartość wybranego pliku do panelu
  tmux send-keys -t "$pane_id" "$command"
fi
