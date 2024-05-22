#!/bin/bash

# 暗号化されたファイルのパスを指定
ENCRYPTED_FILE="passwords.txt.gpg"

# パスフレーズを環境変数から取得
PASSPHRASE="${GPG_PASSPHRASE}"
echo "パスワードマネージャーへようこそ！"
# 無限ループを開始
while true; do
    echo "次の選択肢から入力してください(Add Password/Get Password/Exit)："
    read action  # ユーザーからのアクションを読み取る

    case $action in
        "Add Password")
            echo "サービス名を入力してください："
            read service_name  # サービス名を読み取る
            echo "ユーザー名を入力してください："
            read user_name  # ユーザー名を読み取る
            echo "パスワードを入力してください："
            read -s password  # パスワードを読み取る（画面に表示されない）
            echo  # 改行を出力

            # 暗号化ファイルが存在するか確認
            if [ -f $ENCRYPTED_FILE ]; then
                # 存在する場合、ファイルを復号化して一時ファイルに出力
                gpg --decrypt --batch --passphrase "$PASSPHRASE" --quiet $ENCRYPTED_FILE > passwords.txt
            else
                # 存在しない場合、新しい一時ファイルを作成
                touch passwords.txt
            fi

            # 新しいパスワードデータを一時ファイルに追加
            echo "$service_name:$user_name:$password" >> passwords.txt

            # 一時ファイルを再暗号化
            gpg --yes --batch --passphrase "$PASSPHRASE" --pinentry-mode loopback --quiet -c passwords.txt
            rm passwords.txt  # 一時ファイルを削除
            echo "パスワードの追加は成功しました"
            ;;
        "Get Password")
            echo "サービス名を入力してください："
            read service_name  # サービス名を読み取る

            # 暗号化ファイルが存在するか確認
            if [ -f $ENCRYPTED_FILE ]; then
                # 存在する場合、ファイルを復号化して一時ファイルに出力
                gpg --decrypt --batch --passphrase "$PASSPHRASE" --quiet --pinentry-mode loopback $ENCRYPTED_FILE > passwords.txt

                # 指定されたサービス名でデータを検索
                result=$(grep "^$service_name:" passwords.txt)
                if [ -z "$result" ]; then
                    echo "そのサービスは登録されていません。"
                else
                    # ユーザー名とパスワードを表示
                    user_name=$(echo "$result" | cut -d ':' -f 2)
                    password=$(echo "$result" | cut -d ':' -f 3)
                    echo "サービス名：$service_name"
                    echo "ユーザー名：$user_name"
                    echo "パスワード：$password"
                fi
                rm passwords.txt  # 一時ファイルを削除
            else
                echo "そのサービスは登録されていません。"
            fi
            ;;
        "Exit")
            echo "Thank you!"
            break  # ループを終了
            ;;
        *)
            echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
            ;;
    esac
done