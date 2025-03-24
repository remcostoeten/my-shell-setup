from flask import Flask, request, jsonify, render_template_string
import requests
from bs4 import BeautifulSoup
import re
import json
import logging
import uuid

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

# Store temporary page data for selector interface
page_cache = {}

def fetch_page(url):
    """Fetch a page and return its HTML content"""
    try:
        response = requests.get(url)
        response.raise_for_status()
        return response.text
    except Exception as e:
        logging.error(f"Error fetching {url}: {str(e)}")
        return None

def extract_content_structure(url, selectors=None):
    """Scrape a documentation page and extract its structure based on selectors"""
    try:
        html_content = fetch_page(url)
        if not html_content:
            return {"error": "Failed to fetch the page"}
        
        soup = BeautifulSoup(html_content, 'html.parser')
        
        # Use default selectors if none provided
        if not selectors:
            selectors = {
                "title": "h1",
                "content_container": ".fumadocs-content, article",
                "headings": "h1, h2, h3, h4, h5, h6",
                "paragraphs": "p",
                "code_blocks": "pre",
                "lists": "ul, ol",
                "metadata": ".metadata .meta-item"
            }
        
        # Extract title
        title_element = soup.select_one(selectors.get("title", "h1"))
        title_text = title_element.text.strip() if title_element else "Unknown Title"
        
        # Extract main content
        content_selector = selectors.get("content_container", ".fumadocs-content, article")
        content_div = soup.select_one(content_selector)
        
        if not content_div:
            return {"error": f"Could not find main content container using selector: {content_selector}"}
        
        # Extract headings and their content
        sections = []
        current_heading = None
        current_content = []
        current_heading_level = 0
        
        heading_selector = selectors.get("headings", "h1, h2, h3, h4, h5, h6")
        paragraph_selector = selectors.get("paragraphs", "p")
        code_selector = selectors.get("code_blocks", "pre")
        list_selector = selectors.get("lists", "ul, ol")
        
        # Combine selectors for finding all relevant elements in order
        all_selectors = f"{heading_selector}, {paragraph_selector}, {code_selector}, {list_selector}"
        
        for element in content_div.select(all_selectors):
            if element.name.startswith('h'):
                # Save previous section if exists
                if current_heading:
                    sections.append({
                        "heading": current_heading,
                        "level": current_heading_level,
                        "content": "\n".join(current_content)
                    })
                
                # Start new section
                current_heading = element.text.strip()
                current_heading_level = int(element.name[1])
                current_content = []
            else:
                # Add to current section content
                if element.name == 'pre':
                    # Handle code blocks
                    code = element.text.strip()
                    language = ""
                    if element.select_one('code[class]'):
                        class_attr = element.select_one('code[class]').get('class')
                        language_match = re.search(r'language-(\w+)', str(class_attr))
                        if language_match:
                            language = language_match.group(1)
                    
                    current_content.append(f"```{language}\n{code}\n```")
                elif element.name in ['ul', 'ol']:
                    # Handle lists
                    list_items = [f"- {li.text.strip()}" for li in element.select('li')]
                    current_content.append("\n".join(list_items))
                else:
                    current_content.append(element.text.strip())
        
        # Add the last section
        if current_heading:
            sections.append({
                "heading": current_heading,
                "level": current_heading_level,
                "content": "\n".join(current_content)
            })
        
        # Extract metadata if available
        metadata = {}
        metadata_selector = selectors.get("metadata", ".metadata .meta-item")
        for item in soup.select(metadata_selector):
            key_element = item.select_one('.key')
            value_element = item.select_one('.value')
            if key_element and value_element:
                metadata[key_element.text.strip()] = value_element.text.strip()
        
        return {
            "url": url,
            "title": title_text,
            "sections": sections,
            "metadata": metadata
        }
    
    except Exception as e:
        logging.error(f"Error scraping {url}: {str(e)}")
        return {"error": str(e)}

@app.route('/scrape', methods=['GET', 'POST'])
def scrape_docs():
    if request.method == 'POST':
        data = request.get_json()
        url = data.get('url')
        selectors = data.get('selectors')
    else:
        url = request.args.get('url')
        selectors = None
    
    if not url:
        return jsonify({"error": "URL parameter is required"}), 400
    
    result = extract_content_structure(url, selectors)
    return jsonify(result)

@app.route('/preview', methods=['POST'])
def preview_page():
    url = request.form.get('url')
    if not url:
        return jsonify({"error": "URL is required"}), 400
    
    html_content = fetch_page(url)
    if not html_content:
        return jsonify({"error": "Failed to fetch the page"}), 400
    
    # Generate a unique ID for this preview session
    session_id = str(uuid.uuid4())
    page_cache[session_id] = html_content
    
    return jsonify({"session_id": session_id})

@app.route('/selector', methods=['GET'])
def selector_interface():
    session_id = request.args.get('session_id')
    if not session_id or session_id not in page_cache:
        return "Invalid or expired session", 400
    
    html_content = page_cache[session_id]
    
    # Inject our selector tool into the page
    soup = BeautifulSoup(html_content, 'html.parser')
    
    # Add our selector script to the head
    script_tag = soup.new_tag('script')
    script_tag.string = """
    document.addEventListener('DOMContentLoaded', function() {
        // Add selector tool styles
        const style = document.createElement('style');
        style.textContent = `
            .selector-highlight { 
                outline: 2px solid red !important; 
                background-color: rgba(255, 0, 0, 0.1) !important;
            }
            #selector-controls {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                background: #333;
                color: white;
                z-index: 10000;
                padding: 10px;
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
            }
            #selector-controls button {
                padding: 5px 10px;
                background: #4CAF50;
                color: white;
                border: none;
                cursor: pointer;
            }
            #selector-controls input {
                padding: 5px;
                width: 250px;
            }
            .selector-item {
                display: flex;
                align-items: center;
                gap: 5px;
            }
            body {
                margin-top: 60px !important;
            }
        `;
        document.head.appendChild(style);
        
        // Add selector controls
        const controls = document.createElement('div');
        controls.id = 'selector-controls';
        controls.innerHTML = `
            <div class="selector-item">
                <label>Title:</label>
                <input type="text" id="title-selector" placeholder="h1" value="h1">
                <button onclick="highlightSelector('title-selector')">Test</button>
            </div>
            <div class="selector-item">
                <label>Content Container:</label>
                <input type="text" id="container-selector" placeholder=".fumadocs-content, article" value=".fumadocs-content, article">
                <button onclick="highlightSelector('container-selector')">Test</button>
            </div>
            <div class="selector-item">
                <label>Headings:</label>
                <input type="text" id="headings-selector" placeholder="h1, h2, h3, h4, h5, h6" value="h1, h2, h3, h4, h5, h6">
                <button onclick="highlightSelector('headings-selector')">Test</button>
            </div>
            <div class="selector-item">
                <label>Paragraphs:</label>
                <input type="text" id="paragraphs-selector" placeholder="p" value="p">
                <button onclick="highlightSelector('paragraphs-selector')">Test</button>
            </div>
            <div class="selector-item">
                <label>Code Blocks:</label>
                <input type="text" id="code-selector" placeholder="pre" value="pre">
                <button onclick="highlightSelector('code-selector')">Test</button>
            </div>
            <div class="selector-item">
                <label>Lists:</label>
                <input type="text" id="lists-selector" placeholder="ul, ol" value="ul, ol">
                <button onclick="highlightSelector('lists-selector')">Test</button>
            </div>
            <div class="selector-item">
                <label>Metadata:</label>
                <input type="text" id="metadata-selector" placeholder=".metadata .meta-item" value=".metadata .meta-item">
                <button onclick="highlightSelector('metadata-selector')">Test</button>
            </div>
            <button onclick="scrapeWithSelectors()">Scrape with these selectors</button>
        `;
        document.body.insertBefore(controls, document.body.firstChild);
        
        // Add selector tool scripts
        window.highlightSelector = function(inputId) {
            // Clear previous highlights
            document.querySelectorAll('.selector-highlight').forEach(el => {
                el.classList.remove('selector-highlight');
            });
            
            const selector = document.getElementById(inputId).value;
            try {
                const elements = document.querySelectorAll(selector);
                elements.forEach(el => {
                    el.classList.add('selector-highlight');
                });
                
                if (elements.length === 0) {
                    alert('No elements found with this selector');
                } else {
                    alert(`Found ${elements.length} elements with this selector`);
                }
            } catch (e) {
                alert('Invalid selector: ' + e.message);
            }
        };
        
        window.scrapeWithSelectors = function() {
            const selectors = {
                title: document.getElementById('title-selector').value,
                content_container: document.getElementById('container-selector').value,
                headings: document.getElementById('headings-selector').value,
                paragraphs: document.getElementById('paragraphs-selector').value,
                code_blocks: document.getElementById('code-selector').value,
                lists: document.getElementById('lists-selector').value,
                metadata: document.getElementById('metadata-selector').value
            };
            
            // Get the URL from the page
            const url = window.location.href.split('/selector')[0] + '/get_original_url?session_id=' + new URLSearchParams(window.location.search).get('session_id');
            
            fetch(url)
                .then(response => response.json())
                .then(data => {
                    const originalUrl = data.url;
                    
                    // Send the selectors to the scrape endpoint
                    return fetch('/scrape', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            url: originalUrl,
                            selectors: selectors
                        })
                    });
                })
                .then(response => response.json())
                .then(result => {
                    // Open a new window with the results
                    const resultWindow = window.open('', '_blank');
                    resultWindow.document.write(`
                        <html>
                            <head>
                                <title>Scrape Results</title>
                                <style>
                                    body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
                                    pre { background: #f4f4f4; padding: 10px; overflow: auto; }
                                </style>
                            </head>
                            <body>
                                <h1>Scrape Results</h1>
                                <h2>Selectors Used:</h2>
                                <pre>${JSON.stringify(selectors, null, 2)}</pre>
                                <h2>Data Extracted:</h2>
                                <pre>${JSON.stringify(result, null, 2)}</pre>
                            </body>
                        </html>
                    `);
                })
                .catch(error => {
                    alert('Error: ' + error.message);
                });
        };
        
        // Add click listener to all elements for easy selector generation
        document.addEventListener('click', function(e) {
            // Don't interfere with our control panel
            if (e.target.closest('#selector-controls')) {
                return;
            }
            
            e.preventDefault();
            e.stopPropagation();
            
            // Generate a good selector for this element
            let selector = generateSelector(e.target);
            
            // Prompt user to choose which selector to update
            const selectorType = prompt(
                `Click detected on element with selector: ${selector}\n\n` +
                `Which selector would you like to update?\n` +
                `1. Title\n` +
                `2. Content Container\n` +
                `3. Headings\n` +
                `4. Paragraphs\n` +
                `5. Code Blocks\n` +
                `6. Lists\n` +
                `7. Metadata\n` +
                `Enter a number or cancel:`
            );
            
            if (!selectorType) return;
            
            const selectorMap = {
                '1': 'title-selector',
                '2': 'container-selector',
                '3': 'headings-selector',
                '4': 'paragraphs-selector',
                '5': 'code-selector',
                '6': 'lists-selector',
                '7': 'metadata-selector'
            };
            
            const inputId = selectorMap[selectorType];
            if (inputId) {
                document.getElementById(inputId).value = selector;
                highlightSelector(inputId);
            }
            
            return false;
        }, true);
        
        // Helper function to generate a good CSS selector for an element
        function generateSelector(el) {
            if (el.id) {
                return '#' + el.id;
            }
            
            if (el.classList.length > 0) {
                return el.tagName.toLowerCase() + '.' + Array.from(el.classList).join('.');
            }
            
            return el.tagName.toLowerCase();
        }
    });
    """
    soup.head.append(script_tag)
    
    # Store the original URL for this session
    url = request.args.

_**Note:** Response was truncated due to length limits._

from flask import Flask, request, jsonify, render_template_string
import requests
from bs4 import BeautifulSoup
import re
import json
import logging
import uuid

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

# Store temporary page data for selector interface
page_cache = {}

def fetch_page(url):
    """Fetch a page and return its HTML content"""
    try:
        response = requests.get(url)
        response.raise_for_status()
        return response.text
    except Exception as e:
        logging.error(f"Error fetching {url}: {str(e)}")
        return None

def extract_content_structure(url, selectors=None):
    """Scrape a documentation page and extract its structure based on selectors"""
    try:
        html_content = fetch_page(url)
        if not html_content:
            return {"error": "Failed to fetch the page"}
        
        soup = BeautifulSoup(html_content, 'html.parser')
        
        # Use default selectors if none provided
        if not selectors:
            selectors = {
                "title": "h1",
                "content_container": ".fumadocs-content, article",
                "headings": "h1, h2, h3, h4, h5, h6",
                "paragraphs": "p",
                "code_blocks": "pre",
                "lists": "ul, ol",
                "metadata": ".metadata .meta-item"
            }
        
        # Extract title
        title_element = soup.select_one(selectors.get("title", "h1"))
        title_text = title_element.text.strip() if title_element else "Unknown Title"
        
        # Extract main content
        content_selector = selectors.get("content_container", ".fumadocs-content, article")
        content_div = soup.select_one(content_selector)
        
        if not content_div:
            return {"error": f"Could not find main content container using selector: {content_selector}"}
        
        # Extract headings and their content
        sections = []
        current_heading = None
        current_content = []
        current_heading_level = 0
        
        heading_selector = selectors.get("headings", "h1, h2, h3, h4, h5, h6")
        paragraph_selector = selectors.get("paragraphs", "p")
        code_selector = selectors.get("code_blocks", "pre")
        list_selector = selectors.get("lists", "ul, ol")
        
        # Combine selectors for finding all relevant elements in order
        all_selectors = f"{heading_selector}, {paragraph_selector}, {code_selector}, {list_selector}"
        
        for element in content_div.select(all_selectors):
            if element.name.startswith('h'):
                # Save previous section if exists
                if current_heading:
                    sections.append({
                        "heading": current_heading,
                        "level": current_heading_level,
                        "content": "\n".join(current_content)
                    })
                
                # Start new section
                current_heading = element.text.strip()
                current_heading_level = int(element.name[1])
                current_content = []
            else:
                # Add to current section content
                if element.name == 'pre':
                    # Handle code blocks
                    code = element.text.strip()
                    language = ""
                    if element.select_one('code[class]'):
                        class_attr = element.select_one('code[class]').get('class')
                        language_match = re.search(r'language-(\w+)', str(class_attr))
                        if language_match:
                            language = language_match.group(1)
                    
                    current_content.append(f"```{language}\n{code}\n```")
                elif element.name in ['ul', 'ol']:
                    # Handle lists
                    list_items = [f"- {li.text.strip()}" for li in element.select('li')]
                    current_content.append("\n".join(list_items))
                else:
                    current_content.append(element.text.strip())
        
        # Add the last section
        if current_heading:
            sections.append({
                "heading": current_heading,
                "level": current_heading_level,
                "content": "\n".join(current_content)
            })
        
        # Extract metadata if available
        metadata = {}
        metadata_selector = selectors.get("metadata", ".metadata .meta-item")
        for item in soup.select(metadata_selector):
            key_element = item.select_one('.key')
            value_element = item.select_one('.value')
            if key_element and value_element:
                metadata[key_element.text.strip()] = value_element.text.strip()
        
        return {
            "url": url,
            "title": title_text,
            "sections": sections,
            "metadata": metadata
        }
    
    except Exception as e:
        logging.error(f"Error scraping {url}: {str(e)}")
        return {"error": str(e)}

@app.route('/scrape', methods=['GET', 'POST'])
def scrape_docs():
    if request.method == 'POST':
        data = request.get_json()
        url = data.get('url')
        selectors = data.get('selectors')
    else:
        url = request.args.get('url')
        selectors = None
    
    if not url:
        return jsonify({"error": "URL parameter is required"}), 400
    
    result = extract_content_structure(url, selectors)
    return jsonify(result)

@app.route('/preview', methods=['POST'])
def preview_page():
    url = request.form.get('url')
    if not url:
        return jsonify({"error": "URL is required"}), 400
    
    html_content = fetch_page(url)
    if not html_content:
        return jsonify({"error": "Failed to fetch the page"}), 400
    
    # Generate a unique ID for this preview session
    session_id = str(uuid.uuid4())
    page_cache[session_id] = html_content
    
    return jsonify({"session_id": session_id})

@app.route('/selector', methods=['GET'])
def selector_interface():
    session_id = request.args.get('session_id')
    if not session_id or session_id not in page_cache:
        return "Invalid or expired session", 400
    
    html_content = page_cache[session_id]
    
    # Inject our selector tool into the page
    soup = BeautifulSoup(html_content, 'html.parser')
    
    # Add our selector script to the head
    script_tag = soup.new_tag('script')
    script_tag.string = """
    document.addEventListener('DOMContentLoaded', function() {
        // Add selector tool styles
        const style = document.createElement('style');
        style.textContent = `
            .selector-highlight { 
                outline: 2px solid red !important; 
                background-color: rgba(255, 0, 0, 0.1) !important;
            }
            #selector-controls {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                background: #333;
                color: white;
                z-index: 10000;
                padding: 10px;
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
            }
            #selector-controls button {
                padding: 5px 10px;
                background: #4CAF50;
                color: white;
                border: none;
                cursor: pointer;
            }
            #selector-controls input {
                padding: 5px;
                width: 250px;
            }
            .selector-item {
                display: flex;
                align-items: center;
                gap: 5px;
            }
            body {
                margin-top: 60px !important;
            }
        `;
        document.head.appendChild(style);
        
        // Add selector controls
        const controls = document.createElement('div');
        controls.id = 'selector-controls';
        controls.innerHTML = `
            <div class="selector-item">
                <label>Title:</label>
                <input type="text" id="title-selector" placeholder="h1" value="h1">
                <button onclick="highlightSelector('title-selector')">Test</button>
            </div>
            <div class="selector-item">
                <label>Content Container:</label>
                <input type="text" id="container-selector" placeholder=".fumadocs-content, article" value=".fumadocs-content, article">
                <button onclick="highlightSelector('container-selector')">Test</button>
            </div>
            <div class="selector-item">
                <label>Headings:</label>
                <input type="text" id="headings-selector" placeholder="h1, h2, h3, h4, h5, h6" value="h1, h2, h3, h4, h5, h6">
                <button onclick="highlightSelector('headings-selector')">Test</button>
            </div>
            <div class="selector-item">
                <label>Paragraphs:</label>
                <input type="text" id="paragraphs-selector" placeholder="p" value="p">
                <button onclick="highlightSelector('paragraphs-selector')">Test</button>
            </div>
            <div class="selector-item">
                <label>Code Blocks:</label>
                <input type="text" id="code-selector" placeholder="pre" value="pre">
                <button onclick="highlightSelector('code-selector')">Test</button>
            </div>
            <div class="selector-item">
                <label>Lists:</label>
                <input type="text" id="lists-selector" placeholder="ul, ol" value="ul, ol">
                <button onclick="highlightSelector('lists-selector')">Test</button>
            </div>
            <div class="selector-item">
                <label>Metadata:</label>
                <input type="text" id="metadata-selector" placeholder=".metadata .meta-item" value=".metadata .meta-item">
                <button onclick="highlightSelector('metadata-selector')">Test</button>
            </div>
            <button onclick="scrapeWithSelectors()">Scrape with these selectors</button>
        `;
        document.body.insertBefore(controls, document.body.firstChild);
        
        // Add selector tool scripts
        window.highlightSelector = function(inputId) {
            // Clear previous highlights
            document.querySelectorAll('.selector-highlight').forEach(el => {
                el.classList.remove('selector-highlight');
            });
            
            const selector = document.getElementById(inputId).value;
            try {
                const elements = document.querySelectorAll(selector);
                elements.forEach(el => {
                    el.classList.add('selector-highlight');
                });
                
                if (elements.length === 0) {
                    alert('No elements found with this selector');
                } else {
                    alert(`Found ${elements.length} elements with this selector`);
                }
            } catch (e) {
                alert('Invalid selector: ' + e.message);
            }
        };
        
        window.scrapeWithSelectors = function() {
            const selectors = {
                title: document.getElementById('title-selector').value,
                content_container: document.getElementById('container-selector').value,
                headings: document.getElementById('headings-selector').value,
                paragraphs: document.getElementById('paragraphs-selector').value,
                code_blocks: document.getElementById('code-selector').value,
                lists: document.getElementById('lists-selector').value,
                metadata: document.getElementById('metadata-selector').value
            };
            
            // Get the URL from the page
            const url = window.location.href.split('/selector')[0] + '/get_original_url?session_id=' + new URLSearchParams(window.location.search).get('session_id');
            
            fetch(url)
                .then(response => response.json())
                .then(data => {
                    const originalUrl = data.url;
                    
                    // Send the selectors to the scrape endpoint
                    return fetch('/scrape', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            url: originalUrl,
                            selectors: selectors
                        })
                    });
                })
                .then(response => response.json())
                .then(result => {
                    // Open a new window with the results
                    const resultWindow = window.open('', '_blank');
                    resultWindow.document.write(`
                        <html>
                            <head>
                                <title>Scrape Results</title>
                                <style>
                                    body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
                                    pre { background: #f4f4f4; padding: 10px; overflow: auto; }
                                </style>
                            </head>
                            <body>
                                <h1>Scrape Results</h1>
                                <h2>Selectors Used:</h2>
                                <pre>${JSON.stringify(selectors, null, 2)}</pre>
                                <h2>Data Extracted:</h2>
                                <pre>${JSON.stringify(result, null, 2)}</pre>
                            </body>
                        </html>
                    `);
                })
                .catch(error => {
                    alert('Error: ' + error.message);
                });
        };
        
        // Add click listener to all elements for easy selector generation
        document.addEventListener('click', function(e) {
            // Don't interfere with our control panel
            if (e.target.closest('#selector-controls')) {
                return;
            }
            
            e.preventDefault();
            e.stopPropagation();
            
            // Generate a good selector for this element
            let selector = generateSelector(e.target);
            
            // Prompt user to choose which selector to update
            const selectorType = prompt(
                `Click detected on element with selector: ${selector}\n\n` +
                `Which selector would you like to update?\n` +
                `1. Title\n` +
                `2. Content Container\n` +
                `3. Headings\n` +
                `4. Paragraphs\n` +
                `5. Code Blocks\n` +
                `6. Lists\n` +
                `7. Metadata\n` +
                `Enter a number or cancel:`
            );
            
            if (!selectorType) return;
            
            const selectorMap = {
                '1': 'title-selector',
                '2': 'container-selector',
                '3': 'headings-selector',
                '4': 'paragraphs-selector',
                '5': 'code-selector',
                '6': 'lists-selector',
                '7': 'metadata-selector'
            };
            
            const inputId = selectorMap[selectorType];
            if (inputId) {
                document.getElementById(inputId).value = selector;
                highlightSelector(inputId);
            }
            
            return false;
        }, true);
        
        // Helper function to generate a good CSS selector for an element
        function generateSelector(el) {
            if (el.id) {
                return '#' + el.id;
            }
            
            if (el.classList.length > 0) {
                return el.tagName.toLowerCase() + '.' + Array.from(el.classList).join('.');
            }
            
            return el.tagName.toLowerCase();
        }
    });
    """
    soup.head.append(script_tag)
    
    # Store the original URL for this session
    url = request.args.
    url = request.args.get("original_url")

_**Note:** Response was truncated due to length limits._

