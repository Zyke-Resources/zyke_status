return {
    ["noPermission"] = {msg = "この操作を行う権限がありません。", type = "error"},
    ["noSelfIdentifier"] = {msg = "キャラクターIDが見つかりませんでした。", type = "error"},
    ["noTargetIdentifier"] = {msg = "キャラクターIDが見つかりませんでした。", type = "error"},
    ["invalidTargetId"] = {msg = "ターゲットIDが無効です。", type = "error"},
    ["playerHealed"] = {msg = "プレイヤーが治療されました。", type = "success"},
    ["noServerHeal"] = {msg = "サーバーを治療することはできません。", type = "error"},
    ["playerStatusFrozen"] = {msg = "プレイヤーのステータスが凍結されました。", type = "success"},
    ["playerStatusUnfrozen"] = {msg = "プレイヤーのステータスの凍結が解除されました。", type = "success"},
    ["noServerFreeze"] = {msg = "サーバーを凍結することはできません。", type = "error"},

    ["stress1"] = {msg = "少しストレスを感じています。", type = "info"},
    ["stress2"] = {msg = "かなりストレスを感じています。", type = "error"},
    ["stress3"] = {msg = "非常にストレスを感じています。", type = "error"},
    ["stress4"] = {msg = "極度のストレスを感じています。", type = "error"},
    ["stress5"] = {msg = "危険なレベルのストレスを感じています。", type = "error"},

    ["hunger1"] = {msg = "お腹が鳴り始めています。", type = "info"},
    ["hunger2"] = {msg = "とてもお腹が空いています。", type = "error"},
    ["hunger3"] = {msg = "飢え死にしそうです。", type = "error"},
    ["hunger4"] = {msg = "餓死寸前です。", type = "error"},

    -- Dev command stuff
    ["invalidAmount"] = {msg = "無効な量です。", type = "error"},
    ["incorrectAction"] = {msg = "アクションの入力が正しくありません", type = "error"},
    ["statusSaved"] = {msg = "ステータスがデータベースに保存されました。", type = "success"},
}
