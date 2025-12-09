import { useEffect, useState } from "react";


export default function App() {
const [reports, setReports] = useState([]);


useEffect(() => {
fetch("http://localhost:8000/reports")
.then((r) => r.json())
.then(setReports)
.catch(() => {});
}, []);


return (
<div className="p-6 font-sans">
<h1 className="text-2xl mb-4">Pegasus Checker — Reports</h1>
<ul>
{reports.map((r) => (
<li key={r} className="mb-2 p-2 rounded bg-gray-100">
{r}
</li>
))}
</ul>
</div>
);
}