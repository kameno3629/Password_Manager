#!/bin/bash

echo "パスワードマネージャーへようこそ！"
echo "サービス名を入力してください："
read service_name
echo "ユーザー名を入力してください："
read user_name
echo "パスワードを入力してください："
read password

# 入力された情報をファイルに保存
echo "$service_name:$user_name:$password" >> passwords.txt

echo "Thank you!"