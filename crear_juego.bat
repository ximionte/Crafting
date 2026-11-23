@echo off
chcp 65001 > nul
echo Generando el archivo index.html de Alquimia Infinita...

(
echo ^<!DOCTYPE html^>
echo ^<html lang="es"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>Alquimia Infinita: Fantasia^</title^>
echo     ^<style^>
echo         :root {
echo             --bg-color: #0f172a;
echo             --sidebar-bg: #1e293b;
echo             --item-bg: #334155;
echo             --item-hover: #475569;
echo             --text-color: #f8fafc;
echo             --accent: #8b5cf6;
echo             --new-discovery: #eab308;
echo         }
echo         * { box-sizing: border-box; user-select: none; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
echo         body { margin: 0; padding: 0; display: flex; height: 100vh; background-color: var(--bg-color); color: var(--text-color); overflow: hidden; }
echo         #canvas { flex: 1; position: relative; background-image: radial-gradient(#334155 1px, transparent 1px); background-size: 25px 25px; overflow: hidden; }
echo         #game-title { position: absolute; top: 15px; left: 20px; font-size: 1.5rem; font-weight: bold; color: rgba(255, 255, 255, 0.7); pointer-events: none; }
echo         #controls { position: absolute; bottom: 20px; left: 20px; display: flex; gap: 10px; }
echo         button { background-color: var(--item-bg); color: white; border: 1px solid #475569; padding: 8px 15px; border-radius: 8px; cursor: pointer; font-size: 0.9rem; transition: 0.2s; }
echo         button:hover { background-color: var(--accent); border-color: var(--accent); }
echo         #sidebar { width: 320px; background-color: var(--sidebar-bg); border-left: 2px solid #334155; display: flex; flex-direction: column; z-index: 10; }
echo         #search-box { padding: 15px; border-bottom: 1px solid #334155; }
echo         #search-input { width: 100%%; padding: 10px; border-radius: 8px; border: 1px solid #475569; background-color: var(--bg-color); color: white; font-size: 1rem; outline: none; }
echo         #search-input:focus { border-color: var(--accent); }
echo         #inventory { flex: 1; padding: 15px; overflow-y: auto; display: flex; flex-wrap: wrap; align-content: flex-start; gap: 8px; }
echo         .element { display: inline-flex; align-items: center; gap: 6px; background-color: var(--item-bg); border: 1px solid #475569; padding: 8px 14px; border-radius: 10px; font-size: 1rem; font-weight: 500; cursor: grab; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3); transition: transform 0.1s, background-color 0.2s; }
echo         .element:hover { background-color: var(--item-hover); transform: scale(1.03); }
echo         .element:active { cursor: grabbing; }
echo         .canvas-item { position: absolute; z-index: 5; }
echo         .new-badge { border-color: var(--new-discovery); box-shadow: 0 0 12px rgba(234, 179, 8, 0.5); animation: pop 0.3s ease-out; }
echo         @keyframes pop { 0%% { transform: scale(0.5); } 80%% { transform: scale(1.15); } 100%% { transform: scale(1); } }
echo     ^</style^>
echo ^</head^>
echo ^<body^>
echo     ^<div id="canvas"^>
echo         ^<div id="game-title"^>✨ Alquimia Infinita: Fantasia^</div^>
echo         ^<div id="controls"^>
echo             ^<button onclick="clearCanvas()"^>🧹 Limpiar Tablero^</button^>
echo             ^<button onclick="resetProgress()" style="background-color: #7f1d1d;"^>⚠️ Reiniciar Todo^</button^>
echo         ^</div^>
echo     ^</div^>
echo     ^<div id="sidebar"^>
echo         ^<div id="search-box"^>
echo             ^<input type="text" id="search-input" placeholder="🔍 Buscar elemento..." oninput="filterInventory()"^>
echo         ^</div^>
echo         ^<div id="inventory"^>^</div^>
echo     ^</div^>
echo     ^<script^>
echo         const initialElements = [
echo             { name: "Agua", emoji: "💧" },
echo             { name: "Fuego", emoji: "🔥" },
echo             { name: "Tierra", emoji: "🌍" },
echo             { name: "Viento", emoji: "💨" },
echo             { name: "Magia", emoji: "✨" }
echo         ];
echo         const recipes = {
echo             "Agua+Fuego": { name: "Vapor", emoji: "♨️" },
echo             "Agua+Tierra": { name: "Barro", emoji: "💩" },
echo             "Fuego+Tierra": { name: "Lava", emoji: "🌋" },
echo             "Fuego+Viento": { name: "Humo", emoji: "💨" },
echo             "Agua+Viento": { name: "Nube", emoji: "☁️" },
echo             "Tierra+Viento": { name: "Polvo", emoji: "🌫️" },
echo             "Magia+Tierra": { name: "Golem", emoji: "🗿" },
echo             "Magia+Fuego": { name: "Fenix", emoji: "🔥" },
echo             "Magia+Agua": { name: "Pocion", emoji: "🧪" },
echo             "Magia+Viento": { name: "Hada", emoji: "🧚" },
echo             "Fuego+Golem": { name: "Dragon", emoji: "🐉" },
echo             "Magia+Magia": { name: "Hechicero", emoji: "🧙" },
echo             "Hechicero+Dragon": { name: "Senor de los Dragones", emoji: "👑" },
echo             "Barro+Fuego": { name: "Ladrillo", emoji: "🧱" },
echo             "Ladrillo+Ladrillo": { name: "Castillo", emoji: "🏰" },
echo             "Castillo+Dragon": { name: "Mazmorra", emoji: "🗝️" },
echo             "Pocion+Hechicero": { name: "Alquimista", emoji: "⚗️" },
echo             "Nube+Fuego": { name: "Rayo", emoji: "⚡" },
echo             "Rayo+Magia": { name: "Tormenta Arcana", emoji: "⛈️" },
echo             "Tierra+Agua": { name: "Planta", emoji: "🌱" },
echo             "Planta+Magia": { name: "Arbol Ent", emoji: "🌳" },
echo             "Arbol Ent+Hada": { name: "Bosque Encantado", emoji: "🍄" }
echo         };
echo         const fantasyPrefixes = ["Mistico", "Oscuro", "Celestial", "Maldito", "Sagrado", "Antiguo", "Etereo", "Cristalino", "Infernal", "Elfico", "Enano", "Cosmico"];
echo         const fantasyEmojis = ["🔮", "⚔️", "🛡️", "🦄", "👻", "💀", "👽", "💎", "👑", "📜", "🕯️", "🌌", "☄️", "🧿"];
echo         let discovered = JSON.parse(localStorage.getItem('alchemy_discovered')) ^|^| [...initialElements];
echo         let customRecipes = JSON.parse(localStorage.getItem('alchemy_custom')) ^|^| {};
echo         const canvas = document.getElementById('canvas');
echo         const inventory = document.getElementById('inventory');
echo         function saveProgress() {
echo             localStorage.setItem('alchemy_discovered', JSON.stringify(discovered));
echo             localStorage.setItem('alchemy_custom', JSON.stringify(customRecipes));
echo         }
echo         function renderInventory(filter = "") {
echo             inventory.innerHTML = "";
echo             discovered.filter(el =^> el.name.toLowerCase().includes(filter.toLowerCase())).forEach(el =^> {
echo                 const div = document.createElement('div');
echo                 div.className = 'element';
echo                 div.innerHTML = `^<span^>${el.emoji}^</span^> ^<span^>${el.name}^</span^>`;
echo                 div.onmousedown = (e) =^> spawnOnCanvas(el, e);
echo                 inventory.appendChild(div);
echo             });
echo         }
echo         function filterInventory() { renderInventory(document.getElementById('search-input').value); }
echo         function spawnOnCanvas(elementData, e, x = null, y = null, isNew = false) {
echo             const item = document.createElement('div');
echo             item.className = 'element canvas-item' + (isNew ? ' new-badge' : '');
echo             item.innerHTML = `^<span^>${elementData.emoji}^</span^> ^<span^>${elementData.name}^</span^>`;
echo             item.dataset.name = elementData.name;
echo             item.dataset.emoji = elementData.emoji;
echo             item.style.left = `${x !== null ? x : e.clientX - 40}px`;
echo             item.style.top = `${y !== null ? y : e.clientY - 20}px`;
echo             canvas.appendChild(item);
echo             makeDraggable(item, e !== null);
echo             return item;
echo         }
echo         function makeDraggable(el, startDraggingImmediately = false) {
echo             let isDragging = startDraggingImmediately;
echo             let offsetX = 40, offsetY = 20;
echo             const onMouseMove = (e) =^> {
echo                 if (!isDragging) return;
echo                 el.style.left = `${e.clientX - offsetX}px`;
echo                 el.style.top = `${e.clientY - offsetY}px`;
echo                 el.style.zIndex = 100;
echo             };
echo             const onMouseUp = (e) =^> {
echo                 if (!isDragging) return;
echo                 isDragging = false;
echo                 el.style.zIndex = 5;
echo                 document.removeEventListener('mousemove', onMouseMove);
echo                 document.removeEventListener('mouseup', onMouseUp);
echo                 if (e.clientX ^> canvas.offsetWidth) { el.remove(); return; }
echo                 checkCollision(el);
echo             };
echo             el.onmousedown = (e) =^> {
echo                 e.stopPropagation();
echo                 if (e.button === 2) {
echo                     spawnOnCanvas({ name: el.dataset.name, emoji: el.dataset.emoji }, null, parseInt(el.style.left) + 15, parseInt(el.style.top) + 15);
echo                     return;
echo                 }
echo                 isDragging = true;
echo                 offsetX = e.clientX - el.getBoundingClientRect().left;
echo                 offsetY = e.clientY - el.getBoundingClientRect().top;
echo                 document.addEventListener('mousemove', onMouseMove);
echo                 document.addEventListener('mouseup', onMouseUp);
echo             };
echo             el.oncontextmenu = (e) =^> e.preventDefault();
echo             if (startDraggingImmediately) {
echo                 document.addEventListener('mousemove', onMouseMove);
echo                 document.addEventListener('mouseup', onMouseUp);
echo             }
echo         }
echo         function checkCollision(draggedEl) {
echo             const rect1 = draggedEl.getBoundingClientRect();
echo             for (let otherEl of document.querySelectorAll('.canvas-item')) {
echo                 if (otherEl === draggedEl) continue;
echo                 const rect2 = otherEl.getBoundingClientRect();
echo                 if (!(rect1.right ^< rect2.left ^|^| rect1.left ^> rect2.right ^|^| rect1.bottom ^< rect2.top ^|^| rect1.top ^> rect2.bottom)) {
echo                     combineElements(draggedEl, otherEl);
echo                     break;
echo                 }
echo             }
echo         }
echo         function combineElements(el1, el2) {
echo             const name1 = el1.dataset.name, name2 = el2.dataset.name;
echo             const key = [name1, name2].sort().join('+');
echo             let result = recipes[key] ^|^| customRecipes[key];
echo             if (!result) {
echo                 const prefix = fantasyPrefixes[Math.floor(Math.random() * fantasyPrefixes.length)];
echo                 const emoji = fantasyEmojis[Math.floor(Math.random() * fantasyEmojis.length)];
echo                 result = { name: `${name1.split(' ').pop()} ${prefix}`, emoji: emoji };
echo                 customRecipes[key] = result;
echo             }
echo             const posX = (parseInt(el1.style.left) + parseInt(el2.style.left)) / 2;
echo             const posY = (parseInt(el1.style.top) + parseInt(el2.style.top)) / 2;
echo             el1.remove(); el2.remove();
echo             const alreadyDiscovered = discovered.some(d =^> d.name === result.name);
echo             if (!alreadyDiscovered) {
echo                 discovered.push(result);
echo                 renderInventory(document.getElementById('search-input').value);
echo             }
echo             saveProgress();
echo             spawnOnCanvas(result, null, posX, posY, !alreadyDiscovered);
echo         }
echo         function clearCanvas() { document.querySelectorAll('.canvas-item').forEach(el =^> el.remove()); }
echo         function resetProgress() {
echo             if (confirm("¿Seguro que quieres borrar todos tus descubrimientos?")) {
echo                 localStorage.removeItem('alchemy_discovered');
echo                 localStorage.removeItem('alchemy_custom');
echo                 discovered = [...initialElements];
echo                 customRecipes = {};
echo                 clearCanvas();
echo                 renderInventory();
echo             }
echo         }
echo         renderInventory();
echo     ^</script^>
echo ^</body^>
echo ^</html^>
) > index.html

echo ¡Listo! Se ha creado index.html en esta misma carpeta.
echo Ya puedes probarlo haciendo doble clic en index.html o subirlo a GitHub.
pause
