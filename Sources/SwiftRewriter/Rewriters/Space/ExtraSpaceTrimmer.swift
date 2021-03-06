import SwiftSyntax

/// Trim 2 or more extra spaces into 1 space.
///
/// - Warning:
/// This rewriter may be a problem
/// if you manually align your code in multiple `=` assignments.
/// Smart alignment rewriter is probably our future.
open class ExtraSpaceTrimmer: SyntaxRewriter
{
    private var _skipsNextLeadingTriva = false

    open override func visit(_ token: TokenSyntax) -> Syntax
    {
        var token2 = token

        if token.leadingTriviaLength.newlines == 0 && !self._skipsNextLeadingTriva
        {
            let lastSpaces = token.leadingTrivia.pieces.last?.isSpace == true ? 1 : 0
            token2 = token2.with(.leadingTrivia, replacingLastSpaces: lastSpaces)
        }

        self._skipsNextLeadingTriva = false

        if token.nextToken?.leadingTrivia.first?.isComment == true {
            // Skip handling trailingTrivia and next leadingTrivia.
            self._skipsNextLeadingTriva = true
        }
        else if token.trailingTriviaLength.newlines == 0 {
            let firstSpaces = token.trailingTrivia.pieces.first?.isSpace == true ? 1 : 0
            token2 = token2.with(.trailingTrivia, replacingFirstSpaces: firstSpaces)
        }

        return super.visit(token2)
    }
}
