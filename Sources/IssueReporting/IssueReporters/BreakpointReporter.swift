#if canImport(Darwin)
  import Darwin

  extension IssueReporter where Self == _BreakpointReporter {
    /// An issue reporter that pauses program execution when a debugger is attached.
    ///
    /// Logs a warning to the console and raises `SIGTRAP` when an issue is received.
    public static var breakpoint: Self { Self() }
  }

  /// A type representing an issue reporter that pauses program execution when a debugger is
  /// attached.
  ///
  /// Use ``IssueReporter/breakpoint`` to create one of these values.
  public struct _BreakpointReporter: IssueReporter {
    public func reportIssue(
      _ message: @autoclosure () -> String?,
      severity: IssueSeverity,
      fileID: StaticString,
      filePath: StaticString,
      line: UInt,
      column: UInt
    ) {
      var message = message() ?? ""
      if message.isEmpty {
        message = "Issue reported"
      }
      printError("\(fileID):\(line): \(message)")
      guard isDebuggerAttached else { return }
      printError(
        """

        Caught debug breakpoint. Type "continue" ("c") to resume execution.
        """
      )
      raise(SIGTRAP)
    }

    var isDebuggerAttached: Bool {
      var name: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
      var info: kinfo_proc = kinfo_proc()
      var info_size = MemoryLayout<kinfo_proc>.size

      return name.withUnsafeMutableBytes {
        $0.bindMemory(to: Int32.self).baseAddress
          .map {
            sysctl($0, 4, &info, &info_size, nil, 0) != -1 && info.kp_proc.p_flag & P_TRACED != 0
          }
          ?? false
      }
    }
  }
#endif
