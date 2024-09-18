
### Delete a specific line
```bash
sed '5d' input.txt
```

### Delete a range of lines
To delete lines 3 through 5 from `input.txt`:

```bash
sed '3,5d' input.txt
```

### Delete all lines except a specific line

To keep only the 5th line and delete all others:

```bash
sed '1,4d;6,$d' input.txt
```

### Delete last line

To delete the last line of a file:
- Use dollar d to delete the last line.

```bash
sed '$d' input.txt
```

The `$` represents the last line.

### Delete lines matching a pattern

To delete lines containing the word "error":

```bash
sed '/error/d' input.txt
```

This uses a regular expression to match lines with "error".

## Important Notes

- By default, sed prints the output with the changes. To modify the original file, use the `-i` option:

  ```bash
  sed -i '[line_number]d' [file_name]
  ```

- To save the changes to a new file instead, use output redirection:

  ```bash
  sed '[line_number]d' [file_name] > [new_file_name]
  ```