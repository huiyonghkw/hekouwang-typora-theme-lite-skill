/* Typora 官网交互：进度 / 光斑 / 磁吸 / 揭示 / 灯箱 —— 无终端站同构换装/对比滑块 */

(function () {
  var bar = document.getElementById("prog");
  if (!bar) return;
  function tick() {
    var h = document.documentElement.scrollHeight - window.innerHeight;
    bar.style.width = (h > 0 ? (window.scrollY / h) * 100 : 0) + "%";
  }
  window.addEventListener("scroll", tick, { passive: true });
  window.addEventListener("resize", tick);
  tick();
})();

(function () {
  var shell = document.getElementById("nav-shell");
  var toggle = document.getElementById("nav-toggle");
  var panel = document.getElementById("nav-panel");
  if (shell) {
    var onScroll = function () {
      if (window.scrollY > 40) shell.classList.add("nav-glass");
      else shell.classList.remove("nav-glass");
    };
    window.addEventListener("scroll", onScroll, { passive: true });
    onScroll();
  }
  if (toggle && panel) {
    toggle.addEventListener("click", function () {
      var open = panel.classList.toggle("open");
      panel.classList.toggle("hidden", !open);
      toggle.setAttribute("aria-expanded", open ? "true" : "false");
    });
    panel.querySelectorAll("a").forEach(function (a) {
      a.addEventListener("click", function () {
        panel.classList.remove("open");
        panel.classList.add("hidden");
        toggle.setAttribute("aria-expanded", "false");
      });
    });
  }
})();

(function () {
  var reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  requestAnimationFrame(function () {
    var copy = document.querySelector(".hero-copy");
    if (copy) copy.classList.add("is-ready");
  });

  var glow = document.getElementById("pointer-glow");
  if (glow && !reduced && window.matchMedia("(pointer:fine)").matches) {
    var gx = window.innerWidth * 0.7;
    var gy = window.innerHeight * 0.25;
    var tx = gx;
    var ty = gy;
    function paint() {
      gx += (tx - gx) * 0.12;
      gy += (ty - gy) * 0.12;
      glow.style.left = gx + "px";
      glow.style.top = gy + "px";
      requestAnimationFrame(paint);
    }
    document.addEventListener(
      "pointermove",
      function (e) {
        tx = e.clientX;
        ty = e.clientY;
        glow.classList.add("on");
      },
      { passive: true }
    );
    document.addEventListener("pointerleave", function () {
      glow.classList.remove("on");
    });
    requestAnimationFrame(paint);
  }

  if (!reduced && window.matchMedia("(pointer:fine)").matches) {
    document.querySelectorAll(".btn-mag").forEach(function (btn) {
      btn.addEventListener("pointermove", function (e) {
        var r = btn.getBoundingClientRect();
        var x = e.clientX - (r.left + r.width / 2);
        var y = e.clientY - (r.top + r.height / 2);
        btn.style.transform =
          "translate(" + (x / r.width) * 14 + "px," + (y / r.height) * 14 + "px)";
      });
      btn.addEventListener("pointerleave", function () {
        btn.style.transform = "";
      });
    });
  }

  document.querySelectorAll(".value-cell").forEach(function (cell) {
    cell.addEventListener("pointermove", function (e) {
      var r = cell.getBoundingClientRect();
      cell.style.setProperty("--mx", e.clientX - r.left + "px");
      cell.style.setProperty("--my", e.clientY - r.top + "px");
    });
  });

  var heroShot = document.getElementById("hero-shot");
  if (heroShot && !reduced) {
    var ticking = false;
    window.addEventListener(
      "scroll",
      function () {
        if (ticking) return;
        ticking = true;
        requestAnimationFrame(function () {
          var y = Math.min(window.scrollY, 720);
          heroShot.style.transform = "translate3d(0," + y * 0.16 + "px,0) scale(1.05)";
          ticking = false;
        });
      },
      { passive: true }
    );
  }

  var els = document.querySelectorAll("[data-reveal]");
  function revealChildren(root) {
    root.querySelectorAll("[data-reveal-child]").forEach(function (kid, i) {
      setTimeout(function () {
        kid.classList.add("in");
      }, reduced ? 0 : 60 * i);
    });
  }
  if (!els.length) return;
  if (!("IntersectionObserver" in window) || reduced) {
    els.forEach(function (e) {
      e.classList.add("in");
      revealChildren(e);
    });
    return;
  }
  var io = new IntersectionObserver(
    function (entries) {
      entries.forEach(function (en) {
        if (!en.isIntersecting) return;
        en.target.classList.add("in");
        revealChildren(en.target);
        io.unobserve(en.target);
      });
    },
    { rootMargin: "0px 0px -10% 0px", threshold: 0.1 }
  );
  els.forEach(function (e) {
    io.observe(e);
  });
})();

(function () {
  var gallery = document.getElementById("gallery");
  var tabs = Array.prototype.slice.call(document.querySelectorAll(".preview-tab[data-gallery]"));
  var rail = document.getElementById("preview-rail");
  var heroA = document.getElementById("preview-hero-img");
  var heroB = document.getElementById("preview-hero-img-b");
  var kicker = document.getElementById("preview-hero-kicker");
  var title = document.getElementById("preview-hero-title");
  var note = document.getElementById("preview-hero-note");
  var indexEl = document.getElementById("preview-hero-index");
  if (!gallery || !rail || !heroA || !heroB) return;

  var thumbs = Array.prototype.slice.call(rail.querySelectorAll(".preview-thumb"));
  var usingA = true;
  var reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  function visibleThumbs() {
    return thumbs.filter(function (t) {
      return t.offsetParent !== null;
    });
  }
  function pad(n) {
    return (n < 10 ? "0" : "") + n;
  }
  function setMeta(thumb, i, total) {
    if (kicker) kicker.textContent = thumb.getAttribute("data-kicker") || "";
    if (title) title.textContent = thumb.getAttribute("data-title") || "";
    if (note) note.textContent = thumb.getAttribute("data-note") || "";
    if (indexEl) indexEl.textContent = pad(i + 1) + " / " + pad(total);
  }
  function activate(thumb, user) {
    if (!thumb) return;
    var list = visibleThumbs();
    var i = list.indexOf(thumb);
    if (i < 0) {
      list = visibleThumbs();
      thumb = list[0] || thumbs[0];
      i = 0;
    }
    var src = thumb.getAttribute("data-src");
    var alt =
      (thumb.getAttribute("data-kicker") || "") +
      " · " +
      (thumb.getAttribute("data-title") || "") +
      " · " +
      (thumb.getAttribute("data-note") || "");
    var incoming = usingA ? heroB : heroA;
    var outgoing = usingA ? heroA : heroB;
    function swap() {
      outgoing.classList.remove("is-active");
      incoming.classList.add("is-active");
      usingA = !usingA;
    }
    incoming.onload = function () {
      swap();
      incoming.onload = null;
    };
    if (incoming.getAttribute("src") === src) {
      swap();
    } else {
      incoming.setAttribute("src", src);
    }
    incoming.setAttribute("alt", alt);
    incoming.setAttribute("aria-hidden", "false");
    outgoing.setAttribute("aria-hidden", "true");
    thumbs.forEach(function (t) {
      var on = t === thumb;
      t.classList.toggle("is-on", on);
      t.setAttribute("aria-selected", on ? "true" : "false");
    });
    rail.setAttribute("aria-activedescendant", thumb.id || "");
    setMeta(thumb, Math.max(0, i), list.length || 1);
    if (user && thumb.scrollIntoView) {
      thumb.scrollIntoView({
        inline: "center",
        block: "nearest",
        behavior: reduced ? "auto" : "smooth",
      });
    }
  }
  function firstVisible() {
    return visibleThumbs()[0] || thumbs[0];
  }

  // initial
  heroA.classList.add("is-active");
  activate(thumbs[0], false);

  thumbs.forEach(function (thumb) {
    thumb.addEventListener("click", function () {
      activate(thumb, true);
    });
  });

  tabs.forEach(function (tab) {
    tab.addEventListener("click", function () {
      var mode = tab.getAttribute("data-gallery");
      if (!mode) return;
      gallery.setAttribute("data-show", mode);
      tabs.forEach(function (t) {
        var on = t === tab;
        t.classList.toggle("is-on", on);
        t.setAttribute("aria-selected", on ? "true" : "false");
      });
      var current = rail.querySelector(".preview-thumb.is-on");
      if (!current || current.offsetParent === null) {
        activate(firstVisible(), true);
      } else {
        activate(current, true);
      }
    });
  });
})();

(function () {
  var stage = document.getElementById("fmt-stage");
  if (!stage) return;
  var items = Array.prototype.slice.call(stage.querySelectorAll("[data-fmt]"));
  var imgA = document.getElementById("fmt-img-a");
  var imgB = document.getElementById("fmt-img-b");
  var caption = document.getElementById("fmt-caption");
  var countEl = document.getElementById("fmt-count");
  var bar = document.getElementById("fmt-progress-bar");
  var pauseBtn = document.getElementById("fmt-pause");
  var prevBtn = document.getElementById("fmt-prev");
  var nextBtn = document.getElementById("fmt-next");
  if (!items.length || !imgA || !imgB) return;

  var labels = items.map(function (el) {
    var spans = el.querySelectorAll("span");
    return (spans[1] && spans[1].textContent) || el.textContent.trim();
  });
  var srcs = labels.map(function (_, i) {
    var n = String(i + 1).padStart(2, "0");
    return "previews/r/formats/f" + n + ".webp";
  });

  var index = 0;
  var usingA = true;
  var paused = false;
  var reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  var DURATION = reduced ? 999999 : 4200;
  var started = 0;
  var raf = 0;
  var visible = false;

  function pad(n) {
    return (n < 10 ? "0" : "") + n;
  }
  function setActiveTab(i) {
    items.forEach(function (el, k) {
      var on = k === i;
      el.classList.toggle("is-on", on);
      el.setAttribute("aria-selected", on ? "true" : "false");
    });
  }
  function show(i, user) {
    index = (i + srcs.length) % srcs.length;
    var nextSrc = srcs[index];
    var nextAlt = labels[index];
    var incoming = usingA ? imgB : imgA;
    var outgoing = usingA ? imgA : imgB;
    incoming.onload = function () {
      outgoing.classList.remove("is-active");
      incoming.classList.add("is-active");
      usingA = !usingA;
    };
    if (incoming.getAttribute("src") === nextSrc) {
      outgoing.classList.remove("is-active");
      incoming.classList.add("is-active");
      usingA = !usingA;
    } else {
      incoming.setAttribute("src", nextSrc);
    }
    incoming.setAttribute("alt", nextAlt);
    incoming.setAttribute("aria-hidden", "false");
    outgoing.setAttribute("aria-hidden", "true");
    if (caption) caption.textContent = pad(index + 1) + " · " + nextAlt;
    if (countEl) countEl.textContent = pad(index + 1) + " / " + pad(srcs.length);
    setActiveTab(index);
    started = performance.now();
    if (bar) bar.style.width = "0%";
    if (user) {
      var active = items[index];
      if (active && active.scrollIntoView) {
        active.scrollIntoView({ block: "nearest", behavior: reduced ? "auto" : "smooth" });
      }
    }
  }
  function tick(now) {
    if (!visible || paused || reduced) {
      raf = requestAnimationFrame(tick);
      return;
    }
    var t = Math.min(1, (now - started) / DURATION);
    if (bar) bar.style.width = t * 100 + "%";
    if (t >= 1) show(index + 1, false);
    raf = requestAnimationFrame(tick);
  }

  items.forEach(function (el) {
    el.addEventListener("click", function () {
      var i = parseInt(el.getAttribute("data-fmt"), 10);
      if (!isNaN(i)) show(i, true);
    });
  });
  if (prevBtn) prevBtn.addEventListener("click", function () { show(index - 1, true); });
  if (nextBtn) nextBtn.addEventListener("click", function () { show(index + 1, true); });
  if (pauseBtn) {
    pauseBtn.addEventListener("click", function () {
      paused = !paused;
      pauseBtn.setAttribute("aria-pressed", paused ? "true" : "false");
      pauseBtn.textContent = paused ? "继续" : "暂停";
      if (!paused) started = performance.now();
    });
  }

  // preload a few ahead
  srcs.slice(0, 4).forEach(function (src) {
    var im = new Image();
    im.src = src;
  });

  if ("IntersectionObserver" in window) {
    var io = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (en) {
          visible = en.isIntersecting;
          if (visible) started = performance.now();
        });
      },
      { threshold: 0.25 }
    );
    io.observe(stage);
  } else {
    visible = true;
  }
  show(0, false);
  raf = requestAnimationFrame(tick);
})();

(function () {
  if (!navigator.clipboard || typeof navigator.clipboard.writeText !== "function") return;
  document.querySelectorAll("pre.sc").forEach(function (pre) {
    var wrap = document.createElement("div");
    wrap.className = "sc-wrap";
    pre.parentNode.insertBefore(wrap, pre);
    wrap.appendChild(pre);
    var btn = document.createElement("button");
    btn.type = "button";
    btn.className = "copy-btn";
    btn.textContent = "复制";
    btn.addEventListener("click", function (e) {
      e.preventDefault();
      var text = pre.innerText
        .split("\n")
        .map(function (line) {
          return line.replace(/^\$ /, "");
        })
        .join("\n");
      navigator.clipboard.writeText(text).then(function () {
        btn.textContent = "已复制";
        btn.classList.add("done");
        setTimeout(function () {
          btn.textContent = "复制";
          btn.classList.remove("done");
        }, 1500);
      });
    });
    wrap.appendChild(btn);
  });
})();

(function () {
  function skip(img) {
    if (!img || !img.getAttribute("src")) return true;
    if (img.classList.contains("no-zoom")) return true;
    return false;
  }
  var imgs = Array.prototype.slice.call(document.querySelectorAll("img")).filter(function (img) {
    return !skip(img);
  });
  if (!imgs.length) return;

  var root = document.createElement("div");
  root.id = "lightbox";
  root.setAttribute("role", "dialog");
  root.setAttribute("aria-modal", "true");
  root.innerHTML =
    '<button type="button" class="lb-close" aria-label="关闭">×</button>' +
    '<span class="lb-count"></span>' +
    '<button type="button" class="lb-prev" aria-label="上一张">‹</button>' +
    '<button type="button" class="lb-next" aria-label="下一张">›</button>' +
    '<div class="lb-stage"><img class="lb-img" alt=""><p class="lb-cap"></p></div>';
  document.body.appendChild(root);

  var stageImg = root.querySelector(".lb-img");
  var cap = root.querySelector(".lb-cap");
  var countEl = root.querySelector(".lb-count");
  var index = 0;
  var open = false;

  imgs.forEach(function (img) {
    img.classList.add("zoomable");
  });

  function show(i) {
    index = (i + imgs.length) % imgs.length;
    var img = imgs[index];
    stageImg.src = img.currentSrc || img.getAttribute("src");
    stageImg.alt = img.getAttribute("alt") || "";
    cap.textContent = img.getAttribute("alt") || "";
    countEl.textContent = index + 1 + " / " + imgs.length;
  }
  function openAt(i) {
    open = true;
    root.classList.add("open");
    document.body.style.overflow = "hidden";
    show(i);
  }
  function close() {
    open = false;
    root.classList.remove("open");
    document.body.style.overflow = "";
  }

  imgs.forEach(function (img, i) {
    img.addEventListener("click", function (e) {
      e.preventDefault();
      openAt(i);
    });
  });
  root.querySelector(".lb-close").addEventListener("click", close);
  root.querySelector(".lb-prev").addEventListener("click", function () {
    show(index - 1);
  });
  root.querySelector(".lb-next").addEventListener("click", function () {
    show(index + 1);
  });
  root.addEventListener("click", function (e) {
    if (e.target === root) close();
  });
  document.addEventListener("keydown", function (e) {
    if (!open) return;
    if (e.key === "Escape") close();
    else if (e.key === "ArrowLeft") show(index - 1);
    else if (e.key === "ArrowRight") show(index + 1);
  });
})();
