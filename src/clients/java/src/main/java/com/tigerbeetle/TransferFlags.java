//////////////////////////////////////////////////////////
// This file was auto-generated by java_bindings.zig
// Do not manually modify.
//////////////////////////////////////////////////////////

package com.tigerbeetle;

public interface TransferFlags {
    int NONE = (int) 0;

    /**
     * @see <a href="https://docs.tigerbeetle.com/reference/transfers#flagslinked">linked</a>
     */
    int LINKED = (int) (1 << 0);

    /**
     * @see <a href="https://docs.tigerbeetle.com/reference/transfers#flagspending">pending</a>
     */
    int PENDING = (int) (1 << 1);

    /**
     * @see <a href="https://docs.tigerbeetle.com/reference/transfers#flagspost_pending_transfer">post_pending_transfer</a>
     */
    int POST_PENDING_TRANSFER = (int) (1 << 2);

    /**
     * @see <a href="https://docs.tigerbeetle.com/reference/transfers#flagsvoid_pending_transfer">void_pending_transfer</a>
     */
    int VOID_PENDING_TRANSFER = (int) (1 << 3);

    /**
     * @see <a href="https://docs.tigerbeetle.com/reference/transfers#flagsdebits_at_most">debits_at_most</a>
     */
    int DEBITS_AT_MOST = (int) (1 << 4);

    /**
     * @see <a href="https://docs.tigerbeetle.com/reference/transfers#flagscredits_at_most">credits_at_most</a>
     */
    int CREDITS_AT_MOST = (int) (1 << 5);

    static boolean hasLinked(final int flags) {
        return (flags & LINKED) == LINKED;
    }

    static boolean hasPending(final int flags) {
        return (flags & PENDING) == PENDING;
    }

    static boolean hasPostPendingTransfer(final int flags) {
        return (flags & POST_PENDING_TRANSFER) == POST_PENDING_TRANSFER;
    }

    static boolean hasVoidPendingTransfer(final int flags) {
        return (flags & VOID_PENDING_TRANSFER) == VOID_PENDING_TRANSFER;
    }

    static boolean hasDebitsAtMost(final int flags) {
        return (flags & DEBITS_AT_MOST) == DEBITS_AT_MOST;
    }

    static boolean hasCreditsAtMost(final int flags) {
        return (flags & CREDITS_AT_MOST) == CREDITS_AT_MOST;
    }

}
