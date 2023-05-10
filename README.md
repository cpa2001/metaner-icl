# MetaNER-ICL

- An implementation for ACL 2023 paper ``Learning In-context Learning for Named Entity Recognition``

## Quick links

* [Environment](#Environment)
* [Pre-training](#pre-training)
* [In-context Learning](#in-context-learning)
* [Fewshot Fine-tuning](#Fewshot-Fine-tuning)
* [Model Evaluation](#Model-Evaluation)

### Environment

```bash
conda create -n metaner python=3.9.0
conda activate metaner
bash env.sh
```
### Pre-training

The pretrain data is in the 

We use one A100-80g to pre-train the t5-v1_1-large and you can run:

```bash
python pretrain_full.py --plm google/t5-v1_1-large --do_train --per_device_train_batch_size 8 --learning_rate 5e-5 \
--logging_step 1000 \
--output_dir plm/metaner \
--datasetconfig config/pretrain/pretrain_dataset.yaml \
--evaluation_strategy steps \
--do_eval \
--per_device_eval_batch_size 32 \
--metric_for_best_model f1 \
--eval_steps 10000 \
--max_steps 500000 \
--save_steps 10000 \
--lr_scheduler_type constant_with_warmup \
--warmup_steps 10000 \
--save_total_limit 50 \
--remove_unused_columns False \
--dataset pretrain 
```
The pretraining dataset should be putted in path `pretrain/`
```text
pretrain/
├── ICL_train.json
├── ICL_dev.json
├── label2id.json
├── code2name.json
└── lmtrain.json
```
where ICL_train.json and ICL_dev.json are the NER dataset from wikipedia and wikidata, label2id.json is used for ner pre-training, code2name.json is the wikidata code and label name mapping file, lmtrain.json is used for pseudo extraction language modeling task.

### In-context Learning
You can run:
```bash
python predictor.py --output_dir tmp/conll03/metaner-icl \
--plm plm/metaner \
--formatsconfig config/formats/metaner.yaml \
--testset data/conll03 \
--do_predict \
--remove_unused_columns False \
--shot_num 5 \
--per_device_eval_batch_size 16
```
The result will be in output_dir. You can change the `shot_num` for different shot and `testset` for different dataset.

For different pre-trained model, you should change `plm` and `formatsconfig`.

For t5 model, you can change the formatsconfig to `config/formats/t5.yaml`. For gpt/opt model, you can change the formatsconfig to `config/formats/gpt.yaml`.

### Model Evaluation
You can run:
```bash
python getresult.py -modelpath tmp/conll03/metaner-icl
```
Note that due to possible variations in the order of demonstrations, there may be a slight performance difference, approximately 1%.

### Fewshot Fine-tuning

run:

```bash
python finetuning.py -dataset conll03 --shot 5 --plm plm/metaner --formatsconfig config/formats/finetune/t5.yaml --output_dir tmp/conll03/metaner-ft \
```
The result will be in output_dir. You can change the `shot` for different shot and `dataset` for different dataset.

For different pre-trained model, you should change `plm` and `formatsconfig`.

For t5/metaner model, the formatsconfig should be `config/formats/finetune/t5.yaml`. For gpt model, it should be `config/formats/finetune/t5.yaml`.
