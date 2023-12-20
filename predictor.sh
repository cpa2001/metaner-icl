python predictor_bart.py --output_dir tmp/conll03/bart-icl \
--plm bart-base \
--formatsconfig config/formats/bart.yaml \
--testset data/conll03 \
--do_predict \
--remove_unused_columns False \
--shot_num 5 \
--per_device_eval_batch_size 4
