function setUpContextMenus() {
  chrome.contextMenus.create({
    title: "Save selection to engram",
    id: "selection",
    contexts: ["all"],
  });
}

chrome.runtime.onInstalled.addListener(function () {
  // When the app gets installed, set up the context menus
  setUpContextMenus();
});

chrome.contextMenus.onClicked.addListener(function (itemData, tab) {
  const selectionText = itemData.selectionText;
  const url = `https://engram.xyzdigital.com/quick-capture?body=${selectionText}`;
  chrome.tabs.create({ url });
});
