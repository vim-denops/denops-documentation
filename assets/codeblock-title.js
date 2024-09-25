document.addEventListener("DOMContentLoaded", () => {
  const codeblocks = document.querySelectorAll("pre code");
  codeblocks.forEach((codeblock) => {
    const found = [...codeblock.classList.values()].find((v) =>
      v.startsWith("title=")
    );
    if (found) {
      const title = found.replace(/^title=/, "");
      const titleElement = document.createElement("header");
      titleElement.classList.add("codeblock-title");
      titleElement.textContent = title;
      codeblock.parentNode.prepend(titleElement, codeblock);
    }
  });
});
