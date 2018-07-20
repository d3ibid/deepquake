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
CURRENT_ENVIRONMENT=`ls -d /scratch/nas/4/rtous`/convnetquake
source $CURRENT_ENVIRONMENT/bin/activate
cd /scratch/nas/4/rtous/deepquake/
#export PYTHONPATH=.
#./util_read_metadata.py --stream_path input/funvisis/sfiles_nordicformat/05-0420-00L.S201502

python step1_preprocess1_funvisis2oklahoma.py \
--pattern 05-0420-00L* \
--output_dir ./output/test

python step2_preprocess2_create_tfrecords_positives.py \
--dataset_dir ./output/test \
--output_dir ./output/test/tfrecords

python step3_preprocess3_create_tfrecords_negatives.py \
--dataset_dir ./output/test \
--output_dir ./output/test/tfrecords

python step4_train.py \
--dataset_dir ./output/test/tfrecords \
--checkpoint_dir ./output/test/checkpoints

python step6_predict.py \
--stream_path ./output/test/mseed \
--output_dir ./output/test/predict \
--checkpoint_dir ./output/test/checkpoints

### Copiar salida (comprimida)
#gzip -c $DATA/output-$1-$2 > $CSCRATCH/out/output-$1-$2.gz

### Borrar zona datos local
rm -rf $DATA



