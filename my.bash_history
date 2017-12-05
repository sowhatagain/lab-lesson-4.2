# подготовка к работе с файлом

sort -k1 -n r/ratings.csv > r/rt.csv.sorted

# train, test файлы
mrec_prepare --dataset r/rt.csv --delimiter "," --outdir r/splits --rating_thresh 4 --test_size 0.5 --binarize

# подготовка среды
ipcluster start -n 4 --daemonize

# SLIM параметры по умолчанию

mrec_train -n4 --input_format tsv --train "r/splits/rt.csv.train.*" --outdir r/models
mrec_predict --input_format tsv --test_input_format tsv --train "r/splits/rt.csv.train.*" --modeldir r/models --outdir r/recs > r/slim.info


# SLIM подбор регуляризации, варианты прогона

mrec_train -n 4 --input_format tsv --train "r/splits/rt.csv.train.0" --outdir r/models --l1_reg 0.01 --l2_reg 0.01
mrec_predict --input_format tsv --test_input_format tsv --train "r/splits/rt.csv.train.0" --modeldir r/models --outdir r/recs
mrec_train -n 4 --input_format tsv --train "r/splits/rt.csv.train.0" --outdir r/models --l1_reg 0.1 --l2_reg 0.01
mrec_predict --input_format tsv --test_input_format tsv --train "r/splits/rt.csv.train.0" --modeldir r/models --outdir r/recs

#SLIM с подобранными параметрами

mrec_train -n4 --input_format tsv --train "r/splits/rt.csv.train.*" --outdir r/models --l1_reg 0.001 --l2_reg 0.001
mrec_predict --input_format tsv --test_input_format tsv --train "r/splits/rt.csv.train.*" --modeldir r/models --outdir r/recs


KNN

# используем те же train, test файлы, что подготовлены заранее.
# cosine

mrec_train -n 4 --input_format tsv --train "r/splits/rt.csv.train.*" --outdir r/models --models knn
mrec_predict --iput_format tsv --test_input_format tsv --train "r/splits/rt.csv.train*" --modeldir r/models --outdir r/recs

# dot

mrec_train -n 4 --input_format tsv --train "r/splits/rt.csv.train.*" --outdir r/models --models knn --metric dot
mrec_predict --iput_format tsv --test_input_format tsv --train "r/splits/rt.csv.train*" --modeldir r/models --outdir r/recs

