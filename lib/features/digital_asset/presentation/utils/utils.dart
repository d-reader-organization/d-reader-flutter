String shortenDigitalAssetName(String digitalAssetName) =>
    '#${digitalAssetName.split('#').last}';
