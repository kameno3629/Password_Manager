#!/bin/bash

while true; do
    echo "パスワードマネージャーへようこそ！"
    echo "次の選択肢から入力してください(Add Password/Get Password/Exit)："
    read action

    case $action in
        "Add Password")
            echo "サービス名を入力してください："
            read service_name
            echo "ユーザー名を入力してください："
            read user_name
            echo "パスワードを入力してください："
            read password
            echo "$service_name:$user_name:$password" >> passwords.txt
            echo "パスワードの追加は成功しました。"
            ;;
        "Get Password")
            echo "サービス名を入力してください："
            read service_name
            grep "^$service_name:" passwords.txt > /dev/null
            if [ $? -eq 0 ]; then
                grep "^$service_name:" passwords.txt | cut -d ':' -f 2,3
            else
                echo "そのサービスは登録されていません。"
            fi
            ;;
        "Exit")
            echo "Thank you!"
            break
            ;;
        *)
            echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
            ;;
    esac
done