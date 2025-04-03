import sys

def parse_mapping(file_path):
    mapping = {}
    with open(file_path, 'r') as f:
        lines = f.readlines()
        for line in reversed(lines):
            line = line.strip()
            if line.startswith("cv "):
                parts = line.split()[1:]  # Ignore the 'cv' part
                for part in parts:
                    a, b = part.split(":x")
                    mapping[int(a)] = int(b)
                break
    if not mapping:
        raise ValueError("No valid 'cv ' line found in the mapping file.")
    return mapping

def transform_lines(input_file, output_file, mapping):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            if line.startswith("b "):
                _, a_str = line.split()
                a = int(a_str)
                abs_a = abs(a)
                if abs_a in mapping:
                    b = mapping[abs_a]
                    transformed_value = -b if a < 0 else b
                    outfile.write(f"b {transformed_value}\n")
                elif a==0:
                    outfile.write(line)

def main():
    if len(sys.argv) != 4:
        print("Usage: script.py <mapping_file> <input_file> <output_file>")
        sys.exit(1)

    mapping_file = sys.argv[1]
    input_file = sys.argv[2]
    output_file = sys.argv[3]

    try:
        mapping = parse_mapping(mapping_file)
        transform_lines(input_file, output_file, mapping)
        print(f"Transformation complete. Check the output file: {output_file}")
    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
