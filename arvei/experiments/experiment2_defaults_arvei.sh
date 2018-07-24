!/bin/bash
# Must launch with qsub -S /bin/bash ./noise.sh
#!/bin/sh
### Directivas para el gestor de colas (modificar los valores NAMEOFJOB y USERNAME, y mantener la opción "-S")
# Cambiar el nombre del trabajo
#$ -N NAMEOFJOB
# Especificar un shell
#$ -S /bin/sh
# Enviame un correo cuando empiece el trabajo y cuando acabe...
#$ -m be
# ... a esta dirección de correo
#$ -M nobody@ac.upc.edu

CSCRATCH=/scratch/nas/4/`whoami`
DATA=data.$JOB_ID

### Crear zona de datos local y transferir datos
#mkdir $DATA
#rsync $CSCRATCH/exSimul/data $DATA
# La otra opción es que la aplicación lea de $CSCRATCH

### Ejecutar
CURRENT_ENVIRONMENT=`ls -d /scratch/nas/4/rtous`/deepquake_virtualenv
source $CURRENT_ENVIRONMENT/bin/activate
cd /scratch/nas/4/rtous/deepquake/
#export PYTHONPATH=.
#./util_read_metadata.py --stream_path input/funvisis/sfiles_nordicformat/05-0420-00L.S201502

python step1_preprocess1_funvisis2oklahoma.py > stdout_stderr_default_1prep1.txt
python step2_preprocess2_create_tfrecords_positives.py > stdout_stderr_default_2prep2.txt
python step3_preprocess3_create_tfrecords_negatives.py > stdout_stderr_default_3prep3.txt
python step4_train.py > stdout_stderr_default_4train.txt
python step5_eval.py > stdout_stderr_default_5eval.txt

### Copiar salida (comprimida)
#gzip -c $DATA/output-$1-$2 > $CSCRATCH/out/output-$1-$2.gz

### Borrar zona datos local
rm -rf $DATA



