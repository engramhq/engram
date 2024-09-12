window.onload = async function () {
  let [tab] = await chrome.tabs.query({ active: true, currentWindow: true });

  const noteBody = "[" + tab.title + "]" + "(" + tab.url + ")";

  const url = `https://engram.xyzdigital.com/quick-capture?body=${noteBody}`;
  chrome.tabs.create({ url });
  window.close();
};
