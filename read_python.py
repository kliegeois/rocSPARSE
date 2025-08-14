def get_text_between_sequences(text, start_seq, end_seq):
    """
    Extracts the substring between two given sequences.

    Args:
        text (str): The input string.
        start_seq (str): The starting sequence.
        end_seq (str): The ending sequence.

    Returns:
        str or None: The extracted substring, or None if sequences are not found.
    """
    start_index = text.find(start_seq)
    if start_index == -1:
        return None  # Start sequence not found

    # Adjust start_index to point after the start_seq
    start_of_content = start_index + len(start_seq)

    end_index = text.find(end_seq, start_of_content)
    if end_index == -1:
        return None  # End sequence not found

    return text[start_of_content:end_index]

def read_lines_between_sequences(filepath, start_seq, end_seq):
    lines_in_between = []
    try:
        with open(filepath, 'r') as file:
            for line in file:
                tmp = get_text_between_sequences(line, start_seq, end_seq)
                if tmp != None:
                    lines_in_between.append(float(tmp))

    except FileNotFoundError:
        print(f"Error: File not found at {filepath}")
        return []
    except Exception as e:
        print(f"An error occurred: {e}")
        return []

    return lines_in_between

print(read_lines_between_sequences("log.txt", "NT             525825         525825         2100225        1.0000000      0.0000000      default        ", " "))
print(read_lines_between_sequences("log_prof.txt", "NT             525825         525825         2100225        1.0000000      0.0000000      default        ", " "))
