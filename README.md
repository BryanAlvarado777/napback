# NapBack  
NapBack is a pipeline for extracting backbones from Pseudo-Boolean (PB) instances using **Naps** and **Cadiback**. Currently, NapBack assumes that the PB instance is a decision problem. If you are working with an optimization instance, you should add a constraint setting the objective function equal to its optimal value before passing it to NapBack.

## Files  

- **`napback.sh`**  
  - Converts a PB instance into a SAT instance using Naps.  
  - Extracts the variable mapping between PB and SAT using `tac` and `grep`.  
  - Runs Cadiback to extract the backbone of the SAT instance.  
  - Translates the SAT backbone back into a PB backbone using `cnf_backbones_to_pbo.py`.  

- **`cnf_backbones_to_pbo.py`**  
  - A Python script that takes a variable mapping file and a SAT backbone file as input.  
  - Generates the corresponding backbone for the original PB instance.  

- **`napback.def`**  
  - An Apptainer definition file for creating a containerized version of NapBack.  

## Creating the Container  

If you have Apptainer installed, build the container with:  

```sh
apptainer build napback.sif napback.def
```  

This generates the `napback.sif` container.  

## Requirements  

If you are **not** using the containerized version, NapBack requires:  

- **Naps** (expected at `/naps`)  
- **Cadiback** (expected at `/cadiback`)  
- **Utilities**: `tac`, `grep`  
- **Python 3**  
- **`cnf_backbones_to_pbo.py`** (expected in `/scripts`)  

If any paths differ from these defaults, modify `napback.sh` accordingly.  

## Usage  

### Running NapBack Locally  

```sh
./napback.sh <instance_file>
```  

### Running NapBack with the Container  

```sh
apptainer run napback.sif --bind $wkdir:$wkdir $wkdir/<instance_file>
```  

where `$wkdir` is the directory containing the instance file.  

### Output Files  

NapBack generates the following files in the same directory as `<instance_file>`:  

| File Type         | Extension  | Description |
|-------------------|-----------|-------------|
| **CNF file**     | `.cnf`     | PB instance converted into SAT. |
| **Variable map** | `.var_map` | Mapping between PB and SAT variables. |
| **Backbone (CNF)** | `.backbone_cnf` | Backbone extracted from the SAT instance. |
| **Backbone (PB)** | `.backbone` | Backbone converted back to PB. |
| **Log file**     | `.log`     | Logs of the extraction process. |

Each file shares the same name as `<instance_file>`, with the appropriate extension.  

### Custom Output Filenames  

To specify custom filenames for the generated files, use:  

```sh
./napback.sh <instance_file> <cnf_file> <backbone_cnf_file> <backbone_file> <log_file> <var_map_file>
```  

Or, using the containerized version:  

```sh
apptainer run napback.sif --bind $wkdir:$wkdir $wkdir/<instance_file> <cnf_file> <backbone_cnf_file> <backbone_file> <log_file> <var_map_file>
```  
