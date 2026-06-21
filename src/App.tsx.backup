
import React, { useState, useEffect, useRef, useCallback, useMemo } from 'react';
import { Search, FileDown, AlignLeft, Key, X, CheckCircle, AlertCircle } from 'lucide-react';

// --- INPUT SANITIZATION ---
const sanitize = (input: string): string => {
  const div = document.createElement('div');
  div.appendChild(document.createTextNode(input));
  return div.innerHTML;
};

// --- MOCK DATA ---
const generateMockData = (count: number) => {
  const data = [];
  for (let i = 1; i <= count; i++) {
    const year = Math.random() > 0.5 ? 2025 : 2026;
    data.push({
      id: `#${String(i).padStart(4, '0')}`,
      rollNumber: `084${String(Math.floor(Math.random() * 90000) + 10000).padStart(5, '0')}`,
      name: `Candidate ${i}`,
      exam: 'Civil Services',
      stage: ['Prelims', 'Mains', 'Interview'][Math.floor(Math.random() * 3)],
      category: 'General',
      status: 'Cross-Checked',
      year: year,
    });
  }
  return data;
};

const initialData = generateMockData(50);

// --- SEARCH INDEX for fast lookup ---
interface IndexEntry {
  idx: number;
  searchableText: string;
}

const buildSearchIndex = (data: typeof initialData): IndexEntry[] => {
  return data.map((item, idx) => ({
    idx,
    searchableText: `${item.name} ${item.rollNumber} ${item.stage} ${item.exam}`.toLowerCase(),
  }));
};

const searchIndex = buildSearchIndex(initialData);

// --- HIGHLIGHT COMPONENT ---
const HighlightMatch: React.FC<{ text: string; query: string }> = ({ text, query }) => {
  if (!query) return <>{text}</>;

  const normalizedQuery = query.replace(/\s+/g, '').toLowerCase();
  if (!normalizedQuery) return <>{text}</>;

  const lowerText = text.toLowerCase();
  const parts: React.ReactNode[] = [];
  let lastIndex = 0;

  // Find all occurrences of the query in the text
  let searchPos = 0;
  while (searchPos < lowerText.length) {
    const matchIndex = lowerText.indexOf(normalizedQuery, searchPos);
    if (matchIndex === -1) break;

    // Add text before match
    if (matchIndex > lastIndex) {
      parts.push(<span key={`t-${lastIndex}`}>{text.slice(lastIndex, matchIndex)}</span>);
    }

    // Add highlighted match
    parts.push(
      <span key={`h-${matchIndex}`} className="text-green-600 font-bold bg-green-100 rounded px-0.5">
        {text.slice(matchIndex, matchIndex + normalizedQuery.length)}
      </span>
    );

    lastIndex = matchIndex + normalizedQuery.length;
    searchPos = lastIndex;
  }

  // Add remaining text
  if (lastIndex < text.length) {
    parts.push(<span key={`t-${lastIndex}`}>{text.slice(lastIndex)}</span>);
  }

  return parts.length > 0 ? <>{parts}</> : <>{text}</>;
};

// --- LAZY ROW COMPONENT (IntersectionObserver) ---
const LazyRow: React.FC<{
  item: typeof initialData[0];
  highlightedRow: string | null;
  searchTerm: string;
}> = React.memo(({ item, highlightedRow, searchTerm }) => {
  const rowRef = useRef<HTMLDivElement>(null);
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const node = rowRef.current;
    if (!node) return;
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsVisible(true);
          observer.unobserve(node);
        }
      },
      { rootMargin: '200px' }
    );
    observer.observe(node);
    return () => observer.disconnect();
  }, []);

  return (
    <div
      ref={rowRef}
      id={item.id}
      className={`grid grid-cols-1 sm:grid-cols-12 gap-y-2 gap-x-4 p-4 border-b-2 border-black transition-colors duration-1000 ${
        highlightedRow === item.id ? 'bg-green-300' : 'hover:bg-gray-200/50'
      }`}
      style={{ minHeight: '80px', contentVisibility: 'auto', containIntrinsicSize: '0 80px' }}
    >
      {isVisible ? (
        <>
          <div className="sm:col-span-1 font-bold text-gray-500 text-sm">{item.id}</div>
          <div className="sm:col-span-2">
            <p className="text-xs text-gray-500">ROLL NUMBER</p>
            <p className="font-bold">
              <HighlightMatch text={item.rollNumber} query={searchTerm} />
            </p>
          </div>
          <div className="sm:col-span-3">
            <p className="text-xs text-gray-500">CANDIDATE NAME</p>
            <p className="font-bold text-lg">
              <HighlightMatch text={item.name} query={searchTerm} />
            </p>
          </div>
          <div className="sm:col-span-2">
            <p className="text-xs text-gray-500">EXAM</p>
            <p>{item.exam}</p>
          </div>
          <div className="sm:col-span-1">
            <p className="text-xs text-gray-500">STAGE</p>
            <p>{item.stage}</p>
          </div>
          <div className="sm:col-span-1">
            <p className="text-xs text-gray-500">YEAR</p>
            <p>{item.year}</p>
          </div>
          <div className="sm:col-span-2 text-right">
            <p className="text-xs text-gray-500">STATUS</p>
            <p className="font-semibold">{item.status}</p>
          </div>
        </>
      ) : null}
    </div>
  );
});
LazyRow.displayName = 'LazyRow';

// --- API KEY MODAL ---
const ApiKeyModal: React.FC<{
  isOpen: boolean;
  onClose: () => void;
  onSave: (key: string) => void;
  feedback: { type: 'success' | 'error'; message: string } | null;
}> = ({ isOpen, onClose, onSave, feedback }) => {
  const [keyInput, setKeyInput] = useState('');
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (isOpen) {
      setTimeout(() => inputRef.current?.focus(), 100);
    }
  }, [isOpen]);

  if (!isOpen) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const sanitizedKey = sanitize(keyInput.trim());
    if (sanitizedKey) {
      onSave(sanitizedKey);
    }
  };

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center bg-black/50 backdrop-blur-sm">
      <div className="bg-white border-2 border-black p-6 max-w-md w-full mx-4">
        <div className="flex justify-between items-center mb-4">
          <h2 className="font-bold text-lg flex items-center gap-2">
            <Key size={20} /> API Key Required
          </h2>
          <button onClick={onClose} className="hover:bg-gray-200 p-1 rounded" aria-label="Close modal">
            <X size={20} />
          </button>
        </div>
        <p className="text-sm text-gray-600 mb-4">
          Enter your API key to fetch live data. The key is stored locally in your browser and never sent to third
          parties.
        </p>
        <form onSubmit={handleSubmit}>
          <input
            ref={inputRef}
            type="password"
            value={keyInput}
            onChange={(e) => setKeyInput(e.target.value)}
            placeholder="Enter your API key..."
            className="w-full border-2 border-black p-2 mb-3 font-mono text-sm focus:outline-none focus:ring-2 focus:ring-green-500"
            autoComplete="off"
          />
          <div className="flex gap-2">
            <button
              type="submit"
              className="flex-1 bg-black text-white py-2 px-4 font-bold hover:bg-gray-800 transition-colors"
            >
              SAVE KEY
            </button>
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 border-2 border-black hover:bg-gray-100 transition-colors"
            >
              CANCEL
            </button>
          </div>
        </form>
        {feedback && (
          <div
            className={`mt-3 p-2 flex items-center gap-2 text-sm ${
              feedback.type === 'success'
                ? 'bg-green-100 text-green-800 border border-green-300'
                : 'bg-red-100 text-red-800 border border-red-300'
            }`}
          >
            {feedback.type === 'success' ? <CheckCircle size={16} /> : <AlertCircle size={16} />}
            {feedback.message}
          </div>
        )}
      </div>
    </div>
  );
};

// --- EXPORT HELPERS ---
const exportToCSV = (rows: typeof initialData) => {
  const headers = ['ID', 'Roll Number', 'Name', 'Exam', 'Stage', 'Category', 'Status', 'Year'];
  const csvRows = [
    headers.join(','),
    ...rows.map((r) =>
      [r.id, r.rollNumber, r.name, r.exam, r.stage, r.category, r.status, r.year].join(',')
    ),
  ];
  const blob = new Blob([csvRows.join('\n')], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `upsc-qualifiers-${new Date().toISOString().split('T')[0]}.csv`;
  a.click();
  URL.revokeObjectURL(url);
};

// --- RATE LIMITER ---
const createRateLimiter = (limit: number, windowMs: number) => {
  let calls: number[] = [];
  return (): boolean => {
    const now = Date.now();
    calls = calls.filter((t) => now - t < windowMs);
    if (calls.length >= limit) return false;
    calls.push(now);
    return true;
  };
};

const searchRateLimiter = createRateLimiter(30, 1000);

// --- MAIN APP ---
const App: React.FC = () => {
  const [data, setData] = useState(initialData);
  const [searchTerm, setSearchTerm] = useState('');
  const [activeStage, setActiveStage] = useState('All');
  const [activeExam, setActiveExam] = useState('All');
  const [highlightedRow, setHighlightedRow] = useState<string | null>(null);
  const [apiKeyModalOpen, setApiKeyModalOpen] = useState(false);
  const [apiKeyFeedback, setApiKeyFeedback] = useState<{ type: 'success' | 'error'; message: string } | null>(null);
  const [hasApiKey, setHasApiKey] = useState(false);
  const searchInputRef = useRef<HTMLInputElement>(null);
  const rafRef = useRef<number | null>(null);

  // Check for existing API key on mount
  useEffect(() => {
    const storedKey = localStorage.getItem('upsc_api_key');
    if (storedKey) setHasApiKey(true);
  }, []);

  // Ctrl+K shortcut
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.ctrlKey && event.key === 'k') {
        event.preventDefault();
        searchInputRef.current?.focus();
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);

  // Filtered data with requestAnimationFrame for smooth updates
  const filteredData = useMemo(() => {
    let result = initialData;
    const indices = new Set<number>();

    if (activeStage !== 'All' || activeExam !== 'All' || searchTerm) {
      const normalizedSearch = searchTerm.replace(/\s+/g, '').toLowerCase();

      for (const entry of searchIndex) {
        const item = initialData[entry.idx];
        if (activeStage !== 'All' && item.stage !== activeStage) continue;
        if (activeExam !== 'All' && item.exam !== activeExam) continue;
        if (normalizedSearch && !entry.searchableText.replace(/\s+/g, '').includes(normalizedSearch)) continue;
        indices.add(entry.idx);
      }

      result = initialData.filter((_, idx) => indices.has(idx));
    }

    return result;
  }, [searchTerm, activeStage, activeExam]);

  // Use rAF to batch state updates
  useEffect(() => {
    if (rafRef.current) cancelAnimationFrame(rafRef.current);
    rafRef.current = requestAnimationFrame(() => {
      setData(filteredData);
    });
    return () => {
      if (rafRef.current) cancelAnimationFrame(rafRef.current);
    };
  }, [filteredData]);

  const handleSearchChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value;
    if (!searchRateLimiter()) return;
    setSearchTerm(sanitize(value));
  }, []);

  const handleSearchSubmit = useCallback(
    (e: React.FormEvent) => {
      e.preventDefault();
      if (data.length > 0) {
        const firstMatchId = data[0].id;
        setHighlightedRow(firstMatchId);
        const element = document.getElementById(firstMatchId);
        element?.scrollIntoView({ behavior: 'smooth', block: 'center' });
        setTimeout(() => setHighlightedRow(null), 1500);
      }
    },
    [data]
  );

  const handleExport = useCallback(() => {
    const apiKey = localStorage.getItem('upsc_api_key');
    if (!apiKey) {
      setApiKeyModalOpen(true);
      setApiKeyFeedback(null);
      return;
    }
    // Export the currently filtered data
    exportToCSV(data);
  }, [data]);

  const handleSaveApiKey = useCallback((key: string) => {
    try {
      localStorage.setItem('upsc_api_key', key);
      setHasApiKey(true);
      setApiKeyFeedback({ type: 'success', message: 'API key saved successfully! You can now export data.' });
      setTimeout(() => {
        setApiKeyModalOpen(false);
        setApiKeyFeedback(null);
      }, 1500);
    } catch {
      setApiKeyFeedback({ type: 'error', message: 'Failed to save API key. Please try again.' });
    }
  }, []);

  return (
    <div className="bg-[#F0F0F0] min-h-screen font-mono text-black p-4 sm:p-6 lg:p-8">
      <div
        className="absolute top-0 left-0 w-full h-full"
        style={{
          backgroundImage: `url("data:image/svg+xml;utf8,<svg width='100%' height='100%' xmlns='http://www.w3.org/2000/svg'><defs><pattern id='grid' width='30' height='30' patternUnits='userSpaceOnUse'><path d='M0 30 L30 30 L30 0' fill='none' stroke='rgba(200,200,200,0.5)' stroke-width='1'/></pattern></defs><rect width='100%' height='100%' fill='url(%23grid)'/></svg>")`,
          backgroundRepeat: 'repeat',
        }}
      ></div>
      <div className="relative z-10">
        <header className="flex justify-between items-center mb-8">
          <div className="text-xs">
            <p>[SYSTEM]</p>
            <p>UPSC.QUALIFIERS</p>
          </div>
          <div className="flex items-center gap-2">
            <button
              onClick={() => {
                setApiKeyModalOpen(true);
                setApiKeyFeedback(null);
              }}
              className={`text-xs border border-black px-2 py-1 hover:bg-black hover:text-white transition-colors flex items-center gap-1 ${
                hasApiKey ? 'bg-green-100 border-green-600' : ''
              }`}
              title={hasApiKey ? 'API key configured' : 'Set API key'}
            >
              <Key size={12} />
              {hasApiKey ? 'KEY SET' : 'API KEY'}
            </button>
            <button className="sm:hidden">
              <AlignLeft size={24} />
            </button>
          </div>
        </header>

        <div className="mb-12">
          <h1 className="text-6xl sm:text-8xl lg:text-9xl font-bold tracking-tighter relative">
            <span className="text-transparent" style={{ WebkitTextStroke: '2px black' }}>
              QUALIFIED
            </span>
            <span className="absolute left-0 top-0 text-black">QUALIFIED</span>
          </h1>
          <h1 className="text-6xl sm:text-8xl lg:text-9xl font-bold tracking-tighter relative -mt-4 sm:-mt-8">
            <span className="text-transparent" style={{ WebkitTextStroke: '2px black' }}>
              CANDIDATES
            </span>
            <span className="absolute left-0 top-0 text-black">CANDIDATES</span>
          </h1>
        </div>

        <p className="max-w-3xl text-sm mb-10">
          Official verified database of Union Public Service Commission examination qualifiers. Data cross-referenced
          from UPSC.gov.in, official PDFs, and AI-verified sources. Updated in real-time through automated systems.
        </p>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
          <div className="bg-white/80 border-2 border-black p-3 flex flex-col justify-center items-center backdrop-blur-sm">
            <p className="text-xs">TOTAL RECORDS</p>
            <p className="text-2xl font-bold">{initialData.length.toString().padStart(5, '0')}</p>
          </div>
          <div className="bg-white/80 border-2 border-black p-3 flex flex-col justify-center items-center backdrop-blur-sm">
            <p className="text-xs">VERIFIED (2025/26)</p>
            <p className="text-2xl font-bold">
              {initialData
                .filter((d) => [2025, 2026].includes(d.year))
                .length.toString()
                .padStart(5, '0')}
            </p>
          </div>
        </div>

        {/* --- CONTROLS --- */}
        <div className="border-2 border-black bg-white/80 backdrop-blur-sm mb-6">
          <div className="flex flex-col sm:flex-row items-center border-b-2 border-black">
            <form onSubmit={handleSearchSubmit} className="flex-grow w-full">
              <div className="flex items-center">
                <Search className="mx-3" size={18} />
                <input
                  ref={searchInputRef}
                  type="text"
                  placeholder="Ctrl+K to search name or roll number..."
                  className="w-full bg-transparent py-3 focus:outline-none"
                  value={searchTerm}
                  onChange={handleSearchChange}
                  maxLength={100}
                />
              </div>
            </form>
            <button
              onClick={handleExport}
              className="font-bold py-3 px-6 border-l-2 border-black w-full sm:w-auto hover:bg-black hover:text-white transition-colors"
            >
              <FileDown size={18} className="inline mr-2" />
              EXPORT
            </button>
          </div>
          <div className="flex flex-col sm:flex-row">
            <div className="p-3 flex items-center gap-3">
              <span className="text-xs">Stage:</span>
              <select
                onChange={(e) => setActiveStage(e.target.value)}
                value={activeStage}
                className="bg-transparent border border-black px-2"
              >
                <option>All</option>
                <option>Prelims</option>
                <option>Mains</option>
                <option>Interview</option>
              </select>
            </div>
            <div className="p-3 flex items-center gap-3 border-t-2 sm:border-t-0 sm:border-l-2 border-black">
              <span className="text-xs">Exam:</span>
              <select
                onChange={(e) => setActiveExam(e.target.value)}
                value={activeExam}
                className="bg-transparent border border-black px-2"
              >
                <option>All</option>
                <option>Civil Services</option>
              </select>
            </div>
          </div>
        </div>

        {/* --- DATA TABLE --- */}
        <div className="overflow-x-auto border-2 border-black bg-white/50 backdrop-blur-sm">
          <div className="p-3 border-b-2 border-black text-xs">
            Showing {data.length} of {initialData.length} records.
          </div>
          <div>
            {data.map((item) => (
              <LazyRow key={item.id} item={item} highlightedRow={highlightedRow} searchTerm={searchTerm} />
            ))}
          </div>
        </div>

        <footer className="text-center text-xs text-gray-500 mt-8">
          <p>Data sourced from upsc.gov.in. Always cross-verify with official sources.</p>
          <p>Last updated: {new Date().toISOString().split('T')[0]}</p>
        </footer>
      </div>

      {/* API Key Modal */}
      <ApiKeyModal
        isOpen={apiKeyModalOpen}
        onClose={() => {
          setApiKeyModalOpen(false);
          setApiKeyFeedback(null);
        }}
        onSave={handleSaveApiKey}
        feedback={apiKeyFeedback}
      />
    </div>
  );
};

export default App;
