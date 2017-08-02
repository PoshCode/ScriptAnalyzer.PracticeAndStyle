using System;
using System.Globalization;
using System.Management.Automation.Language;

namespace ScriptAnalyzer.PracticeAndStyle
{
	public sealed class ExtendedScriptPosition : IScriptPosition
	{
		private readonly int _offsetInLine;
		private readonly int _scriptLineNumber;
		private readonly string _scriptName;
		private readonly string _line;
		private readonly string _fullScript;
		private readonly int _offset;

		public string File
		{
			get
			{
				return this._scriptName;
			}
		}

		public int LineNumber
		{
			get
			{
				return this._scriptLineNumber;
			}
		}

		public int ColumnNumber
		{
			get
			{
				return this._offsetInLine;
			}
		}

		public int Offset
		{
			get
			{
				return this._offset;
			}
		}

		public string Line
		{
			get
			{
				return this._line;
			}
		}

		public ExtendedScriptPosition(string scriptName, int scriptLineNumber, int offsetInLine, string line, int offset)
		{
			this._scriptName = scriptName;
			this._scriptLineNumber = scriptLineNumber;
			this._offsetInLine = offsetInLine;
			this._offset = offset;
			if (string.IsNullOrEmpty(line))
			{
				this._line = string.Empty;
				return;
			}
			this._line = line;
		}

		public ExtendedScriptPosition(string scriptName, int scriptLineNumber, int offsetInLine, string line, int offset, string fullScript) : this(scriptName, scriptLineNumber, offsetInLine, line, offset)
		{
			this._fullScript = fullScript;
		}

		public string GetFullScript()
		{
			return this._fullScript;
		}
	}

	public sealed class ExtendedScriptExtent : IScriptExtent
	{
		private ExtendedScriptPosition _startPosition;
		private ExtendedScriptPosition _endPosition;

		public string File
		{
			get
			{
				return this._startPosition.File;
			}
		}

		public IScriptPosition StartScriptPosition
		{
			get
			{
				return this._startPosition;
			}
		}

		public IScriptPosition EndScriptPosition
		{
			get
			{
				return this._endPosition;
			}
		}

		public int StartLineNumber
		{
			get
			{
				return this._startPosition.LineNumber;
			}
		}

		public int StartColumnNumber
		{
			get
			{
				return this._startPosition.ColumnNumber;
			}
		}

		public int EndLineNumber
		{
			get
			{
				return this._endPosition.LineNumber;
			}
		}

		public int EndColumnNumber
		{
			get
			{
				return this._endPosition.ColumnNumber;
			}
		}

		public int StartOffset
		{
			get
			{
				return this._startPosition.Offset;
			}
		}

		public int EndOffset
		{
			get
			{
				return this._endPosition.Offset;
			}
		}

		public string Text
		{
			get
			{
				if (this.EndColumnNumber <= 0)
				{
					return string.Empty;
				}
				if (this.StartLineNumber == this.EndLineNumber)
				{
					return this._startPosition.Line.Substring(this._startPosition.ColumnNumber - 1, this._endPosition.ColumnNumber - this._startPosition.ColumnNumber);
				}
				return string.Format(CultureInfo.InvariantCulture, "{0}...{1}", new object[]
				{
					this._startPosition.Line.Substring(this._startPosition.ColumnNumber),
					this._endPosition.Line.Substring(0, this._endPosition.ColumnNumber)
				});
			}
		}

		public ExtendedScriptExtent(ExtendedScriptPosition startPosition, ExtendedScriptPosition endPosition)
		{
			this._startPosition = startPosition;
			this._endPosition = endPosition;
		}
	}
}