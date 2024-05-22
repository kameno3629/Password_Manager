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
            # ファイルからサービス名を検索し、結果を変数に格納
            result=$(grep "^$service_name:" passwords.txt)
            if [ -z "$result" ]; then
                echo "そのサービスは登録されていません。"
            else
                # サービス名が見つかった場合、ユーザー名とパスワードを表示
                echo "$result" | cut -d ':' -f 2,3
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